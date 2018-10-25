#ifndef MEASUREMENTSLISTMANAGER_H
#define MEASUREMENTSLISTMANAGER_H

#include <QObject>
#include <QDebug>
#include <QDateTime>
#include "BaseListManager.h"

class MeasurementsListManager: public BaseListManager
{
    Q_OBJECT
public:
    explicit MeasurementsListManager(DatabaseWorker* db, QObject *parent = nullptr);

    QString getTableName() const override {
        return "measurement";
    }
    QString getCreateQuery() const override;
    QString baseQuery() override {
        return "SELECT * FROM %1 ORDER BY timestamp DESC";
    }

    QVariantMap getDefaults() override;
    Q_INVOKABLE void getLastSequenceNumber(int deviceId);

signals:
    void lastSequenceNumber(int deviceId, int sequenceNumber);
};

#endif // MEASUREMENTSLISTMANAGER_H
