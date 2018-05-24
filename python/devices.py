# -*- coding: utf-8 -*-
from datetime import datetime, timezone
import pyotherside


class Devices:
    database = None
    devices = []
    discovered_devices = []
    discovered_macs = []

    def __init__(self, database):
        self.database = database

        # create table if doesn't exist
        if not self.database.check_if_table_exists("device"):
            # get DB cursor
            cursor = database.cursor

            # create table
            cursor.execute("CREATE TABLE device (" \
                           "device_id integer primary key " \
                           "autoincrement, " \
                           "name text, " \
                           "mac_address text not null, " \
                           "last_sync integer)")
            # save changes
            database.commit()
        self.get(returns=False)

    def get(self, returns=True):
        cursor = self.database.cursor
        self.devices = [
            {
                "id": row[0],
                "name": row[1],
                "mac_address": row[2],
                "last_sync": datetime.fromtimestamp(0) if not row[3] \
                             else datetime.fromtimestamp(row[3])
            } for row in cursor.execute(
                "SELECT * FROM device ORDER BY last_sync DESC")
        ]
        if returns:
            return self.devices

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


    def rename(self, device_id, name, commit=True):
        """
        Renames device to given name
        """
        cursor = self.database.cursor

        cursor.execute("UPDATE device SET name = ? " \
                       "WHERE device_id = ?", (name, device_id, ))

        if commit:
            self.database.commit()

    def update_last_sync(self, device_id, timestamp=None, commit=True):
        """
        Updates last sync in DB after sync.
        """
        cursor = self.database.cursor

        if not timestamp:
            timestamp = datetime.now()

        timestamp = timestamp.replace(tzinfo=timezone.utc).timestamp()

        console.log(timestamp, device_id)

        cursor.execute("UPDATE device SET last_sync = ? " \
                       "WHERE device_id = ?", (timestamp, device_id, ))

        if commit:
            self.database.commit()

    def add(self, name="", mac_address="", remember=True, commit=True):
        """
        Adds device to the database
        """
        cursor = self.database.cursor

        # check if device exists first
        rows = cursor.execute("SELECT mac_address FROM device " \
                              "WHERE mac_address = ?", (mac_address, ))

        if len(rows.fetchall()):
            return

        if remember:
            cursor.execute("INSERT INTO device (name, mac_address) " \
                           "VALUES (?, ?)", (name, mac_address, ))
            if commit:
                self.database.commit()
            self.get(returns=False)

            pyotherside.send("rememberedDevicesChanged", self.devices)
        else:
            if not mac_address in self.discovered_macs:
                self.discovered_macs.append(mac_address)
                self.discovered_devices.append({
                    "name": name,
                    "mac_address": mac_address,
                })
                pyotherside.send("discoveredDevicesChanged",
                                 self.discovered_devices)

    def remove(self, device_id, commit=True):
        """
        Removes device by given ID

        :param id: id of device to remove
        :param commit: if true, changes to the database will be saved,
                       useful for batch processing
        """
        cursor = self.database.cursor

        cursor.execute("DELETE FROM device WHERE device_id = ?",
                       (device_id, ))
        cursor.execute("DELETE FROM measurement WHERE device_id = ?",
                       (device_id, ))

        if commit:
            self.database.commit()
