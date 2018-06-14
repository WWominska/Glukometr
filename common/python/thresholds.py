# -*- coding: utf-8 -*-
from storage import DatabaseModel


class Thresholds(DatabaseModel):
    table = "threshold"
    id_field = "threshold_id"

    model_map = {
        "id": 0,
        "min": 1,
        "max": 2,
        "meal": 3
    }

    def get(self, filter={}, returns=True):
        result = super().get(filter, True)
        self.data = {
            x.get("meal", 0): x
            for x in result
        }
        if returns:
            return result

    def create(self, cursor):
        # create table
        cursor.execute("CREATE TABLE threshold (" \
                       "threshold_id integer primary key " \
                       "autoincrement, " \
                       "min real not null, " \
                       "max real not null, " \
                       "meal integer)")

        # set default values
        self.set_defaults()

    def set_defaults(self):
        self.database.execute("DELETE FROM threshold", commit=False)

        defaults = [{
            "min": 90,
            "max": 130,
            "meal": 0
        }, {
            "min": 90,
            "max": 150,
            "meal": 1
        }, {
            "min": 90,
            "max": 180,
            "meal": 2
        }, {
            "min": 90,
            "max": 140,
            "meal": 3
        }]

        for default in defaults:
            self.add(default, commit=False)

        # save changes to database
        self.database.commit()

    def evaluate_measurement(self, value, meal):
        threshold = self.data.get(meal, {})

        if threshold:
            min = threshold["min"]
            max = threshold["max"]
            if value < min:
                return "red"
            elif value > max:
                return "yellow"
            return "green"
        return "gray"
