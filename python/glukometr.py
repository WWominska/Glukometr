import pyotherside
from storage import Database
from measurements import Measurements
from thresholds import Thresholds
from devices import Devices


database = Database()
measurements = Measurements(database)
thresholds = Thresholds(database)
devices = Devices(database)
