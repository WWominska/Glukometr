import os
import sqlite3
import pyotherside


class Database:
    connection = None
    cursor = None

    def __init__(self, path="%s/.local/share/harbour-glukometr/database.sqlite" % os.path.expanduser("~")):
        # make sure directory exists
        directory = os.path.dirname(path)
        if not os.path.exists(directory):
            os.makedirs(directory)

        # try to connect to the db
        self.connection = sqlite3.connect(path)
        self.cursor = self.connection.cursor()

        # make sure db is closed at exit
        pyotherside.atexit(self.close)

    def execute(self, query, arguments=[], commit=True):
        """Executes given query"""
        self.cursor.execute(query, arguments)

        if commit:
            self.commit()

        return self.cursor.rowcount

    def delete(self, table, field, value, commit=True):
        """Removes row from the DB by given field and value"""
        return self.execute("DELETE FROM %s WHERE %s = ?" % (table, field),
                            (value, ), commit)

    def commit(self):
        """Commits local changes to the database"""
        self.connection.commit()

    def check_if_table_exists(self, table_name):
        """
        Given table name, checks if it exists and returns True or False

        :param table_name: name of table
        """
        # check if table exists
        self.cursor.execute("SELECT name FROM sqlite_master WHERE " \
                            "type='table' AND name=?", (table_name, ))
        results = self.cursor.fetchall()

        return len(results) > 0


    def close(self):
        self.connection.commit()
        self.connection.close()


class DatabaseModel:
    table = ""
    id_field = "id"
    model_map = {
        "id": 0
    }
    database = None
    data = []

    def __init__(self, database):
        self.database = database
        cursor = database.cursor

        if not self.database.check_if_table_exists(self.table):
            self.create(cursor)
            database.commit()

    def create(self, cursor):
        return

    def add(self, obj={}, commit=True):
        """
        Adds object to table of given name

        :param obj: object added to the db
        """
        # if no obj given, do nothing
        if not obj:
            return False

        # generate args string
        query_args_str = ", ".join(["?", ]*len(obj.keys()))

        # generate query
        query = "INSERT INTO %s (%s) VALUES (%s)" % (
            self.table, ", ".join(list(obj.keys())), query_args_str, )

        query_args = list(obj.values())
        return self.database.execute(query, query_args, commit)

    def delete(self, id, commit=True):
        return self.database.delete(self.table, self.id_field, id, commit)

    def update(self, id, obj={}, commit=True):
        if not obj or not id:
            return

        # generate args string
        query_args_str = ", ".join(["%s = ?" % key for key in obj.keys()])

        # generate query
        query = "UPDATE %s SET %s WHERE %s = ?" % (
            self.table, query_args_str, self.id_field)

        query_args = list(obj.values()) + [id, ]

        rows = self.database.execute(query, query_args, commit)
        return rows

    def base_query(self):
        return "SELECT * FROM %s" % self.table

    def get(self, filter={}, returns=True):
        query = self.base_query()
        query_args = []

        if isinstance(filter, dict):
            query += " WHERE %s" % (", ".join(
                ["%s = ?" % key for key in filter.keys()]))
            query_args = list(filter.values())

        cursor = self.database.cursor
        self.data = [
            {
                key: row[index]
                for key, index in self.model_map.items()
            } for row in cursor.execute(query, query_args)
        ]
        if returns:
            return self.data

