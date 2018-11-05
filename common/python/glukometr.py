import pyotherside
from storage import Database
from devices import Devices


database = Database()
devices = Devices(database)
