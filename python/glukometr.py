from datetime import datetime, timezone
from storage import Database
import pyotherside
import sqlite3


class Thresholds:
    database = None
    thresholds = {}

    def __init__(self, database):
        self.database = database

        # get DB cursor
        cursor = database.cursor

        # check if table exists
        cursor.execute("SELECT name FROM sqlite_master WHERE type='table' " \
                       "AND name=?", ("threshold", ))
        results = cursor.fetchall()

        # create table if doesn't exist
        if not len(results):
            cursor.execute("CREATE TABLE threshold (" \
                           "threshold_id integer primary key " \
                           "autoincrement, " \
                           "min real not null, " \
                           "max real not null, " \
                           "meal integer)")
            # save changes
            database.commit()

            # set default values
            self.set_defaults()
        self.get(returns=False)

    def get(self, returns=True):
        cursor = self.database.cursor
        self.thresholds = {
            row[3]: {
                "min": row[1],
                "max": row[2],
            } for row in cursor.execute(
                "SELECT * FROM threshold ORDER BY meal ASC")
        }
        if returns:
            return [{
                "min": row["min"],
                "max": row["max"],
                "meal": key
            } for key, row in self.thresholds.items()]


    def set_defaults(self):
        cursor = self.database.cursor

        cursor.execute("DELETE FROM threshold")
        defaults = [(90, 130, 0), (90, 150, 1), (90, 180, 2), (90, 140, 3), ]
        for default in defaults:
            cursor.execute("INSERT INTO threshold (min, max, meal) " \
                           "VALUES (?, ?, ?)", default)

        # save changes to database
        self.database.commit()

    def update(self, meal=0, min=0, max=0, commit=True):
        """
        Updates threshold for given meal with given data
        """
        cursor = self.database.cursor

        cursor.execute("UPDATE threshold SET min = ?, max = ? " \
                       "WHERE meal = ?", (min, max, meal, ))
        self.thresholds[meal] = {"min": min, "max": max}

        if commit:
            self.database.commit()

    def evaluate_measurement(self, value, meal):
        threshold = self.thresholds.get(meal, {})

        if threshold:
            min = threshold["min"]
            max = threshold["max"]
            if value < min:
                return "yellow"
            elif value > max:
                return "red"
            return "green"
        return "gray"


class Measurements:
    database = None

    def __init__(self, database):
        self.database = database

        # get DB cursor
        cursor = database.cursor

        # check if table exists
        cursor.execute("SELECT name FROM sqlite_master WHERE type='table' " \
                       "AND name=?", ("measurement", ))
        results = cursor.fetchall()

        # create table if doesn't exist
        if not len(results):
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


database = Database()
measurements = Measurements(database)
thresholds = Thresholds(database)
