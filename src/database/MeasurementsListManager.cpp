#include "MeasurementsListManager.h"


MeasurementsListManager::MeasurementsListManager(
        DatabaseWorker *db, QObject *parent) : BaseListManager(db, parent) {}

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
    QDateTime now = QDateTime::currentDateTime();
    return QVariantMap({
       {"meal", 4},
       {"value", 0},
       {"timestamp", now.toTime_t()}
    });
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
