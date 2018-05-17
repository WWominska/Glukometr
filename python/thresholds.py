# -*- coding: utf-8 -*-
class Thresholds:
    database = None
    thresholds = {}

    def __init__(self, database):
        self.database = database

        # create table if doesn't exist
        if not self.database.check_if_table_exists("threshold"):
            # get DB cursor
            cursor = database.cursor

            # create table
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
                return "red"
            elif value > max:
                return "yellow"
            return "green"
        return "gray"
