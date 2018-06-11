# -*- coding: utf-8 -*-
from datetime import datetime, timezone
from storage import DatabaseModel
import pyotherside


class Devices(DatabaseModel):
    table = "device"
    id_field = "device_id"

    model_map = {
        "id": 0,
        "name": 1,
        "mac_address": 2,
        "last_sync": 3
    }

    fallback = {
        "last_sync": -1
    }

    def base_query(self):
        return "SELECT * FROM device ORDER BY last_sync DESC"

    def create(self, cursor):
        cursor.execute("CREATE TABLE device (" \
                       "device_id integer primary key " \
                       "autoincrement, " \
                       "name text, " \
                       "mac_address text not null, " \
                       "last_sync integer)")

    def is_known(self, mac_address):
        cursor = self.database.cursor
        rows = cursor.execute("SELECT mac_address FROM device " \
                              "WHERE mac_address = ?", (mac_address, ))

        return len(rows.fetchall())

    def get_by_mac(self, mac_address):
        """
        Returns device ID for given mac address
        """
        cursor = self.database.cursor

        rows = cursor.execute("SELECT device_id FROM device WHERE " \
                              "mac_address = ?", (mac_address, ))

        try:
            row = rows.fetchone()
            return row[0]
        except:
            return -1

    def update(self, id, obj={}, commit=True):
        if "last_sync" in obj.keys():
            timestamp = obj.get("last_sync", -1)
            if timestamp == -1:
                timestamp = datetime.now()
            obj["last_sync"] = timestamp.timestamp()

        return super().update(id, obj, commit)


    def update_last_sync(self, device_id, timestamp=None, commit=True):
        """
        Updates last sync in DB after sync.
        """
        cursor = self.database.cursor

        if not timestamp:
            timestamp = datetime.now()

        timestamp = timestamp.timestamp()

        cursor.execute("UPDATE device SET last_sync = ? " \
                       "WHERE device_id = ?", (timestamp, device_id, ))

        if commit:
            self.database.commit()

    def add(self, obj={}, commit=True):
        """
        Adds device to the database
        """

        # check if device exists first
        mac_address = obj.get("mac_address", None)
        if self.is_known(mac_address):
            return False

        return super().add(obj, commit)
