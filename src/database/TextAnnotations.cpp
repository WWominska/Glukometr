#include "TextAnnotations.h"

TextAnnotations::TextAnnotations(DatabaseWorker *db, QObject *parent) : BaseListManager(db, parent) {}

QString TextAnnotations::getTableName() const {
    return "annotation_text";
}

QString TextAnnotations::getCreateQuery() const {
    return "CREATE TABLE annotation_text (" \
           "annotation_text_id integer primary key " \
           "autoincrement, " \
           "measurement_id integer REFERENCES " \
           "measurement(measurement_id) ON DELETE cascade, " \
           "content text NOT NULL)";
}
