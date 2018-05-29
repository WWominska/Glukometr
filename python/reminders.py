# -*- coding: utf-8 -*-
from datetime import datetime
import shlex
from subprocess import Popen, PIPE
from storage import DatabaseModel
import pyotherside


class Reminders(DatabaseModel):
    table = "reminder"
    id_field = "reminder_id"
    application_name = "glukometr"

    model_map = {
        "id": 0,
        "timestamp": 1,
        "cookie": 2,
        "repeating": 3,
        "reminder_type": 4
    }

    def call_timedclient(self, args):
        command = "timedclient-qt5 " + args
        with Popen([x.encode("utf-8") for x in shlex.split(command)],
                   stdout=PIPE, stderr=PIPE) as p:
            output, errors = p.communicate()

        lines = output.decode("utf-8").splitlines()
        lines_e = errors.decode("utf-8").splitlines()

        return lines, lines_e


    def create(self, cursor):
        # create table
        cursor.execute("CREATE TABLE reminder (" \
                       "reminder_id integer primary key autoincrement, " \
                       "reminder_datetime text NOT NULL, " \
                       "cookie_id integer, " \
                       "repeating integer, " \
                       "reminder_type integer DEFAULT 0)")

    def cancel(self, cookie):
        output, errors = self.call_timedclient("-c%d" % cookie)
        pyotherside.send("Debug", output)
        pyotherside.send("Errors", output)

    def clear_expired_reminders(self):
        now = datetime.now().timestamp()
        self.database.execute(
            "DELETE FROM reminder WHERE reminder_datetime < ? " \
            "AND repeating = 0", [now, ])

    def get(self, *args, **kwargs):
        self.clear_expired_reminders()
        return super().get(*args, **kwargs)

    def remind(self, title, reminder_type, when=None, repeating=0):
        if not when:
            when = datetime.now()

        time_arg = when.strftime("%Y-%m-%d %H:%M:%S")
        time_of_day = when.hour * 60 + when.minute
        args = "-b'TITLE=button0' "
        args += "-e'APPLICATION=%s;TITLE=%s;type=event;event=reminder;time=%s;timeOfDay=%s'" % (
            self.application_name, title, time_arg, time_of_day)

        if repeating:
            args += " -r'hour=%d;minute=%d;everyDayOfWeek;everyDayOfMonth;everyMonth'" % (
                when.hour, when.minute
            )
            pyotherside.send("Debug", args)

        output, errors = self.call_timedclient(args)

        if output and not errors:
            # it didn't fail, yay
            cookie = output[0].split(" ")[-1]
            self.add({
                "cookie_id": int(cookie),
                "reminder_type": reminder_type,
                "repeating": 0,
                "reminder_datetime": when.timestamp()
            })

        pyotherside.send("Debug", output)
        pyotherside.send("Errors", errors)
