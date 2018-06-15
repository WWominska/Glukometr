# -*- coding: utf-8 -*-
import pyotherside
from storage import DatabaseModel


class Drugs(DatabaseModel):
    table = "drug"
    id_field = "drug_id"

    model_map = {
        "id": 0,
        "name": 1
    }

    def create(self, cursor):
        # create table
        cursor.execute("CREATE TABLE drug (" \
                       "drug_id integer primary key autoincrement, " \
                       "name text)")

        for drug_name in ["Diaprel MR", "Metformax", "Eperzan",
                          "Emagliflozyna", "Starlix"]:
            cursor.execute("INSERT INTO drug (name) VALUES (?)",
                           (drug_name, ))


class MealAnnotations(DatabaseModel):
    table = "annotations_meal"
    id_field = "annotation_meal_id"

    model_map = {
        "id": 0,
        "name": 2,
        "amount": 3,
        "unit": 4
    }

    def create(self, cursor):
        # create table
        cursor.execute("CREATE TABLE annotations_meal (" \
                       "annotation_meal_id integer primary key " \
                       "autoincrement, " \
                       "measurement_id integer REFERENCES " \
                       "measurement(measurement_id) ON DELETE cascade, " \
                       "name text NOT NULL, amount real NOT NULL, " \
                       "unit text NOT NULL)")


class TextAnnotations(DatabaseModel):
    table = "annotations_text"
    id_field = "annotation_text_id"

    model_map = {
        "id": 0,
        "content": 2
    }

    def create(self, cursor):
        # create table
        cursor.execute("CREATE TABLE annotations_text (" \
                       "annotation_text_id integer primary key " \
                       "autoincrement, " \
                       "measurement_id integer REFERENCES " \
                       "measurement(measurement_id) ON DELETE cascade, " \
                       "content text NOT NULL)")


class DrugAnnotations(DatabaseModel):
    table = "annotations_drug"
    id_field = "annotation_drug_id"

    model_map = {
        "id": 0,
        "drug_id": 2,
        "dose": 3,
        "drug_name": 4,
        "unit": 5
    }

    def base_query(self):
        return "SELECT annotation_drug_id, measurement_id, " \
               "annotations_drug.drug_id, dose, " \
               "drug.name, unit from annotations_drug LEFT JOIN drug ON " \
               "annotations_drug.drug_id = drug.drug_id"

    def create(self, cursor):
        # create table
        cursor.execute("CREATE TABLE annotations_drug (" \
                       "annotation_drug_id integer primary key " \
                       "autoincrement, " \
                       "measurement_id integer REFERENCES " \
                       "measurement(measurement_id) ON DELETE cascade, " \
                       "drug_id integer REFERENCES drug(drug_id) " \
                       "ON DELETE cascade, " \
                       "dose real, unit text NOT NULL)")
