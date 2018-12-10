#include "MeasurementsListManager.h"


MeasurementsListManager::MeasurementsListManager(
        DatabaseWorker *db, QObject *parent) : BaseListManager(db, parent) {
    connect(this, &MeasurementsListManager::modelChanged, this, &MeasurementsListManager::getChartData);
}

QString MeasurementsListManager::getCreateQuery() const {
    return "CREATE TABLE IF NOT EXISTS measurement (" \
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

void MeasurementsListManager::getChartData()
{
    QString query = "select COUNT(smaller) as count, SUM(smaller) as "
                    "smaller, SUM(bigger) as bigger, SUM(perfect) as "
                    " perfect FROM (select *, value < min as 'smaller', "
                    "value > max as 'bigger', (value >= min AND value "
                    "<= max) as 'perfect' from measurement left join "
                    "threshold on measurement.meal = threshold.meal)";
    QVariantMap params;
    if (!lastFilter.isEmpty())
        query = QString("%1 WHERE %2").arg(query, keysToBindings(lastFilter, &params));

    this->executeQuery(query,
                       [=](QSqlQuery result) {
        while (result.next()) {
            if (result.value("count").toInt() == 0) {
                m_percentageRed = 0;
                m_percentageGreen = 0;
                m_percentageYellow = 0;
            } else {
                m_percentageRed = (result.value("smaller").toFloat() / result.value("count").toInt()) * 100;
                m_percentageGreen = (result.value("perfect").toFloat() / result.value("count").toInt()) * 100;
                m_percentageYellow = (result.value("bigger").toFloat() / result.value("count").toInt()) * 100;
            }
            emit percentageRedChanged();
            emit percentageGreenChanged();
            emit percentageYellowChanged();
        }
    }, params);
}
