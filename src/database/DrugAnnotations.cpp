#include "DrugAnnotations.h"

DrugAnnotations::DrugAnnotations(DatabaseWorker *db, QObject *parent) : BaseListManager(db, parent) {}

QString DrugAnnotations::getTableName() const {
    return "annotation_drug";
}

QString DrugAnnotations::getCreateQuery() const {
    return "CREATE TABLE annotation_drug (" \
           "annotation_drug_id integer primary key " \
           "autoincrement, " \
           "measurement_id integer REFERENCES " \
           "measurement(measurement_id) ON DELETE cascade, " \
           "drug_id integer REFERENCES drug(drug_id) " \
           "ON DELETE cascade, " \
           "dose real, unit text NOT NULL)";
}

QString DrugAnnotations::baseQuery() {
    return "SELECT annotation_drug_id, measurement_id, " \
           "annotation_drug.drug_id, dose, " \
           "drug.name, unit FROM %1 LEFT JOIN drug ON " \
           "annotation_drug.drug_id = drug.drug_id";
}
