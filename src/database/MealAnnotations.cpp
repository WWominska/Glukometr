#include "MealAnnotations.h"

MealAnnotations::MealAnnotations(DatabaseWorker *db, QObject *parent) : BaseListManager(db, parent) {}

QString MealAnnotations::getTableName() const {
    return "annotation_meal";
}

QString MealAnnotations::getCreateQuery() const {
    return "CREATE TABLE IF NOT EXISTS annotation_meal (" \
           "annotation_meal_id integer primary key " \
           "autoincrement, " \
           "measurement_id integer REFERENCES " \
           "measurement(measurement_id) ON DELETE cascade, " \
           "name text NOT NULL, amount real NOT NULL, " \
           "unit text NOT NULL)";
}
