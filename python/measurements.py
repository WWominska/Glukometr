# -*- coding: utf-8 -*-
from datetime import datetime, timezone
from storage import Database


class Measurements:
    database = None

    def __init__(self, database):
        self.database = database

        # create table if doesn't exist
        if not self.database.check_if_table_exists("measurement"):
            # get DB cursor
            cursor = database.cursor

            # create table
            cursor.execute("CREATE TABLE measurement (" \
                           "measurement_id integer primary key " \
                           "autoincrement, " \
                           "value real not null, " \
                           "timestamp integer not null, " \
                           "device_id integer, " \
                           "sequence_number integer, meal integer)")
            # save changes
            database.commit()

    def get(self):
        cursor = self.database.cursor
        return [{
            "id": row[0],
            "value": row[1],
            "timestamp": datetime.fromtimestamp(row[2]),
            "device_id": row[3],
            "sequence_number": row[4],
            "meal": row[5]
        } for row in cursor.execute(
            "SELECT * FROM measurement ORDER BY timestamp DESC")]

    def add(self, value, timestamp=None, device=None,
                        sequence_number=None, meal=0, commit=True):
        """
        Adds measurement to the database

        """
        cursor = self.database.cursor

        if device and sequence_number:
            # check if measurement exists first
            rows = cursor.execute("SELECT sequence_number FROM measurement " \
                                  "WHERE sequence_number = ? AND " \
                                  "device_id = ?", (sequence_number, device, ))
            if len(rows.fetchall()):
                return

        if not timestamp:
            timestamp = datetime.now()

        timestamp = timestamp.replace(tzinfo=timezone.utc).timestamp()
        cursor.execute("INSERT INTO measurement (" \
                       "value, timestamp, device_id, sequence_number, meal) " \
                       "VALUES (?, ?, ?, ?, ?)", (
                            value, timestamp, device, sequence_number, meal, ))
        if commit:
            self.database.commit()

    def update(self, id, meal=0, commit=True):
        """
        Updates measurement of given ID with given data
        """
        cursor = self.database.cursor

        cursor.execute("UPDATE measurement SET meal = ? " \
                       "WHERE measurement_id = ?", (meal, id, ))
        if commit:
            self.database.commit()

    def get_last_sequence_number(self, device_id):
        """
        Gets last sequence number for given device ID so we can
        avoid getting all measurements twice

        :param device_id: device id for which we want to get sequence number
        """
        cursor = self.database.cursor

        rows = cursor.execute("SELECT sequence_number FROM measurement " \
                              "WHERE device_id = ? ORDER BY sequence_number " \
                              "DESC LIMIT 1", (device_id, ))

        for row in rows:
            return row[0]
        return 0

    def remove(self, id, commit=True):
        """
        Removes measurement by given ID

        :param id: id of measurement to remove
        :param commit: if true, changes to the database will be saved,
                       useful for batch processing
        """
        cursor = self.database.cursor

        cursor.execute("DELETE FROM measurement WHERE measurement_id = ?",
                       (id, ))
        if commit:
            self.database.commit()
