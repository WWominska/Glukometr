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

    def create(self, cursor):
        # create table
        cursor.execute("CREATE TABLE reminder (" \
                       "reminder_id integer primary key autoincrement, " \
                       "reminder_datetime text NOT NULL, " \
                       "cookie_id integer, " \
                       "repeating integer, " \
                       "reminder_type integer DEFAULT 0)")


    def remind(self, title, when=None):
        if not when:
            when = datetime.now()

        time_arg = when.strftime("%Y-%m-%d %H:%M:%S")
        time_of_day = when.hour * 60 + when.minute
        command = "timedclient-qt5 "
        command += "-b'TITLE=button0' "
        command += "-e'APPLICATION=%s;TITLE=%s;type=event;time=%s;timeOfDay=%s'" % (
            self.application_name, title, time_arg, time_of_day)

        with Popen([x.encode("utf-8") for x in shlex.split(command)],
                   stdout=PIPE, stderr=PIPE) as p:
            output, errors = p.communicate()

        lines = output.decode("utf-8").splitlines()
        lines_e = errors.decode("utf-8").splitlines()

        pyotherside.send("Debug", lines)
        pyotherside.send("Errors", lines_e)
