#include "MeasurementsListManager.h"


MeasurementsListManager::MeasurementsListManager(
        DatabaseWorker *db, QObject *parent) : BaseListManager(db, parent) {
    initializeTable();
    getFromDB();
}

QString MeasurementsListManager::getCreateQuery() const {
    return "CREATE TABLE measurement (" \
           "measurement_id integer primary key " \
           "autoincrement, " \
           "value real not null, " \
           "timestamp integer not null, " \
           "device_id integer REFERENCES device(device_id) " \
           "ON DELETE CASCADE, " \
           "sequence_number integer, meal integer)";
}

QVariantMap MeasurementsListManager::getDefaults() {
    QVariantMap defaults;
    QDateTime now = QDateTime::currentDateTime();
    defaults["value"] = 0;
    defaults["timestamp"] = now.toTime_t();
    defaults["meal"] = -1;
    return defaults;
}

void MeasurementsListManager::getLastSequenceNumber(int deviceId) {
    this->executeQuery("SELECT sequence_number FROM measurement " \
                       "WHERE device_id = " + QString::number(deviceId) + " ORDER BY sequence_number " \
                       "DESC LIMIT 1", [=](QSqlQuery result) {
        while (result.next()) {
            emit lastSequenceNumber(deviceId, result.value(0).toInt());
            return;
        }
        emit lastSequenceNumber(deviceId, 0);
    });
}
