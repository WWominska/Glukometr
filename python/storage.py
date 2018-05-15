import os
import sqlite3
import pyotherside


class Database:
    connection = None
    cursor = None

    def __init__(self, path="~/.local/harbour-glukometr/database.sqlite"):
        # make sure directory exists
        directory = os.path.dirname(path)
        if not os.path.exists(directory):
                os.makedirs(directory)

        # try to connect to the db
        self.connection = sqlite3.connect(path)
        self.cursor = self.connection.cursor()

        # make sure db is closed at exit
        pyotherside.atexit(self.close)

    def commit(self):
        """Commits local changes to the database"""
        self.connection.commit()

    def close(self):
        self.connection.commit()
        self.connection.close()
