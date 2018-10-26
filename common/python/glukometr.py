import pyotherside
from storage import Database
from devices import Devices
from reminders import Reminders


database = Database()
devices = Devices(database)
reminders = Reminders(database)
