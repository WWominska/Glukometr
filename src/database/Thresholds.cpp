#include "Thresholds.h"

Thresholds::Thresholds(
        DatabaseWorker *db, QObject *parent) : BaseListManager(db, parent) {
    connect(this, &Thresholds::tableCreated, this, &Thresholds::setDefaults);
    connect(m_model, &SqlQueryModel::modelReset, this, &Thresholds::updateCache);
}

QString Thresholds::getTableName() const {
    return "threshold";
}

QString Thresholds::getCreateQuery() const {
    return "CREATE TABLE threshold (" \
           "threshold_id integer primary key " \
           "autoincrement, " \
           "min real not null, " \
           "max real not null, " \
           "meal integer)";
}

void Thresholds::setDefaults() {
    remove();
    add(QVariantMap({{"min", 90}, {"max", 130}, {"meal", 0}}));
    add(QVariantMap({{"min", 90}, {"max", 150}, {"meal", 1}}));
    add(QVariantMap({{"min", 90}, {"max", 180}, {"meal", 2}}));
    add(QVariantMap({{"min", 90}, {"max", 140}, {"meal", 3}}));
}

void Thresholds::updateCache() {
    // clear cache
    m_thresholdCache.clear();

    // update with min, max and meal values
    for (int i=0; i<m_model->rowCount(); i++) {
        QSqlRecord record = m_model->record(i);
        int key = record.value("meal").toInt();
        int min = record.value("min").toInt();
        int max = record.value("max").toInt();
        m_thresholdCache[key] = QPair<int, int>(min, max);

    }
}

QString Thresholds::evaluateMeasurement(int value, int meal) {
    // create table if it wasn't created when someone wants to use
    // our model
    if (!m_tableCreated)
        initializeTable();

    if (!m_thresholdCache.contains(meal))
        return "gray";
    QPair<int, int> threshold = m_thresholdCache[meal];
    if (value < threshold.first)
        return "red";
    if (value > threshold.second)
        return "yellow";
    return "green";
}

