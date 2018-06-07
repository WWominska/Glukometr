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

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.get(filter=None, returns=False)
        self.cancel_invalid_events()

    def call_timedclient(self, args):
        """Calls timedclient-qt5"""
        command = "timedclient-qt5 " + args
        with Popen([x.encode("utf-8") for x in shlex.split(command)],
                   stdout=PIPE, stderr=PIPE) as p:
            output, errors = p.communicate()

        lines = output.decode("utf-8").splitlines()
        lines_e = errors.decode("utf-8").splitlines()

        # debug
        pyotherside.send("Called", command)
        pyotherside.send("Debug", lines)
        pyotherside.send("Errors", lines_e)

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
        """Cancels reminder in timed service"""
        output, errors = self.call_timedclient("-c%d" % cookie)

    def cancel_invalid_events(self):
        """
        Removes items which are no longer valid, for example ones that should
        be deleted but are still on the list.
        """
        # get cookies by app name
        output, errors = self.call_timedclient(
            "-s'APPLICATION=%s'" % self.application_name)
        try:
            cookies = output[0].split(" ")
        except IndexError:
            return

        # make a list of valid cookies
        valid_cookies = [x.get("cookie", 0) for x in self.data]

        # check which are invalid
        for cookie in cookies:
            if cookie not in valid_cookies:
                # cancel cookie
                try:
                    self.cancel(int(cookie))
                except:
                    pass

    def clear_expired_reminders(self):
        """
        Removes expired reminders from the database
        """
        now = datetime.now().timestamp()
        self.database.execute(
            "DELETE FROM reminder WHERE reminder_datetime < ? " \
            "AND repeating = 0", [now, ])

    def get(self, *args, **kwargs):
        # remove expired reminders first
        self.clear_expired_reminders()
        return super().get(*args, **kwargs)

    def remind(self, title, reminder_type, when=None, repeating=0):
        """
        Adds reminder to timed service and database
        """
        # if date and time not provided, use current one
        if not when:
            when = datetime.now()

        # format time of day
        time_of_day = when.hour * 60 + when.minute

        args = ""
        if repeating:
            # if this event should be repeated, add recurrence args
            flags = "everyDayOfWeek;everyDayOfMonth;everyMonth"
            args = "-r'hour=%s;minute=%s;%s' " % (
                when.hour, when.minute, flags,
            )

        args += "-b'TITLE=button0' "
        args += "-e'APPLICATION=%s;TITLE=%s;type=event;timeOfDay=%s" % (
            self.application_name, title, time_of_day)
        if not repeating:
            # format time argument
            time_arg = when.strftime("%Y-%m-%d %H:%M:%S")
            # add to args
            args += ";time=%s'" % (time_arg)
        else:
            args += "'"

        # call timedclient
        output, errors = self.call_timedclient(args)

        if output and not errors:
            # it didn't fail, yay, add event to the DB
            cookie = output[0].split(" ")[-1]
            self.add({
                "cookie_id": int(cookie),
                "reminder_type": reminder_type,
                "repeating": int(repeating),
                "reminder_datetime": when.timestamp()
            })

