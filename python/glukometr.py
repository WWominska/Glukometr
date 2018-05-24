import pyotherside
from storage import Database
from measurements import Measurements
from thresholds import Thresholds
from devices import Devices
from annotations import Drugs, MealAnnotations, TextAnnotations, \
                        DrugAnnotations


database = Database()
measurements = Measurements(database)
thresholds = Thresholds(database)
devices = Devices(database)
drugs = Drugs(database)
meal_annotations = MealAnnotations(database)
text_annotations = TextAnnotations(database)
drug_annotations = DrugAnnotations(database)
