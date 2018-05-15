from datetime import datetime, timezone
from storage import Database
import pyotherside


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
        } for row in cursor.execute("SELECT * FROM measurement;")]

    def add(self, value, timestamp=None, device=None,
                        sequence_number=None, meal=0, commit=True):
        """
        Adds measurement to the database

        """
        cursor = self.database.cursor

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
