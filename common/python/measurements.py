# -*- coding: utf-8 -*-
from datetime import datetime
from storage import DatabaseModel


class Measurements(DatabaseModel):
    table = "measurement"
    id_field = "measurement_id"

    model_map = {
        "id": 0,
        "value": 1,
        "timestamp": 2,
        "device_id": 3,
        "sequence_number": 4,
        "meal": 5
    }

    def create(self, cursor):
        cursor.execute("CREATE TABLE measurement (" \
                       "measurement_id integer primary key " \
                       "autoincrement, " \
                       "value real not null, " \
                       "timestamp integer not null, " \
                       "device_id integer REFERENCES device(device_id) " \
                       "ON DELETE CASCADE, " \
                       "sequence_number integer, meal integer)")

    def base_query(self):
        return "SELECT * FROM measurement ORDER BY timestamp DESC"

    def add(self, obj={}, commit=True):
        """
        Adds measurement to the database

        """
        cursor = self.database.cursor

        device = obj.get("device", None)
        sequence_number = obj.get("sequence_number", None)

        if device and sequence_number:
            # check if measurement exists first
            rows = cursor.execute("SELECT sequence_number FROM measurement " \
                                  "WHERE sequence_number = ? AND " \
                                  "device_id = ?", (sequence_number, device, ))
            if len(rows.fetchall()):
                return

        timestamp = obj.get("timestamp", None)
        if not timestamp:
            timestamp = datetime.now()
        obj["timestamp"] = timestamp.timestamp()

        return super().add(obj, commit)

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

        try:
            for row in rows:
                return row[0]
        except:
            pass
        return 0
