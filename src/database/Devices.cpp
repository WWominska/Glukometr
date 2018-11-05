#include "Devices.h"

Devices::Devices(
        DatabaseWorker *db, QObject *parent) : BaseListManager(db, parent)
{

}

QString Devices::getTableName() const {
    return "device";
}

QString Devices::getCreateQuery() const {
    return "CREATE TABLE device (" \
           "device_id integer primary key " \
           "autoincrement, " \
           "name text, " \
           "mac_address text not null, " \
           "last_sync integer)";
}

bool Devices::isKnown(QString macAddress)
{
    return getByMac(macAddress).contains("device_id");
}

QSqlRecord Devices::getByMac(QString macAddress)
{
    for (int i=0; i<m_model->rowCount(); i++) {
        QSqlRecord m = m_model->record(i);
        if (m.value("mac_address").toString() == macAddress)
            return m;
    }
    return QSqlRecord();
}

int Devices::getDeviceId(QString macAddress)
{
    QSqlRecord r = getByMac(macAddress);
    if (r.contains("device_id"))
        return r.value("device_id").toInt();
    return -1;
}

void Devices::update(QVariantMap where, QVariantMap fields, bool refresh)
{
    if (fields.contains("last_sync")) {
        int timestamp = fields["last_sync"].toInt();
        if (timestamp < 1)
            timestamp = QDateTime::currentDateTime().toTime_t();
        fields["last_sync"] = timestamp;
    }

    BaseListManager::update(where, fields, refresh);
}

void Devices::updateLastSync(int deviceId, QDateTime timestamp) {
    update(
        QVariantMap({{"device_id", deviceId}}),
        QVariantMap({{"last_sync", timestamp.toTime_t()}}));
}

void Devices::updateLastSync(int deviceId) {
    updateLastSync(deviceId, QDateTime::currentDateTime());
}

void Devices::add(QVariantMap data) {
    // check if device exists first
    if (data.contains("mac_address") && isKnown(data["mac_address"].toString()))
        return;
    BaseListManager::add(data);
}
