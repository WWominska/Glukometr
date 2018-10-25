import pyotherside
from storage import Database
from devices import Devices
from reminders import Reminders
from annotations import Drugs, MealAnnotations, TextAnnotations, \
                        DrugAnnotations


database = Database()
devices = Devices(database)
drugs = Drugs(database)
meal_annotations = MealAnnotations(database)
text_annotations = TextAnnotations(database)
drug_annotations = DrugAnnotations(database)
reminders = Reminders(database)
