#ifndef DEVICES_H
#define DEVICES_H

#include <QObject>
#include <QDateTime>
#include "BaseListManager.h"

class Devices : public BaseListManager
{
    Q_OBJECT
public:
    explicit Devices(DatabaseWorker* db, QObject *parent = nullptr);

    QString getTableName() const override;
    QString getCreateQuery() const override;

public slots:
    Q_INVOKABLE void add(QVariantMap data);
    Q_INVOKABLE void updateLastSync(int deviceId);
    Q_INVOKABLE void updateLastSync(int deviceId, QDateTime timestamp);
    Q_INVOKABLE void update(
            QVariantMap where, QVariantMap fields, bool refresh=true);
    Q_INVOKABLE QSqlRecord getByMac(QString macAddress);
    Q_INVOKABLE bool isKnown(QString macAddress);
    Q_INVOKABLE int getDeviceId(QString macAddress);
};

#endif // DEVICES_H
