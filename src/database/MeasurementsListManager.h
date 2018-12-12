#ifndef MEASUREMENTSLISTMANAGER_H
#define MEASUREMENTSLISTMANAGER_H

#include <QObject>
#include <QDebug>
#include <QDateTime>
#include "BaseListManager.h"

class MeasurementsListManager: public BaseListManager
{
    Q_OBJECT
    Q_PROPERTY(float yellow READ getPercentageYellow NOTIFY percentageYellowChanged)
    Q_PROPERTY(float red READ getPercentageRed NOTIFY percentageRedChanged)
    Q_PROPERTY(float green READ getPercentageGreen NOTIFY percentageGreenChanged)
public:
    explicit MeasurementsListManager(DatabaseWorker* db, QObject *parent = nullptr);

    QString getTableName() const override {
        return "measurement";
    }
    QString getCreateQuery() const override;
    QString baseQuery() override {
        return "SELECT *, date(timestamp, 'unixepoch') as date_measured FROM %1";
    }

    QString orderClause() override {
        return "ORDER BY timestamp DESC";
    }


    QVariantMap getDefaults() override;
    Q_INVOKABLE void getLastSequenceNumber(int deviceId);
    Q_INVOKABLE void getChartData();

    float getPercentageYellow() {
        return m_percentageYellow;
    }
    float getPercentageGreen() {
        return m_percentageGreen;
    }
    float getPercentageRed() {
        return m_percentageRed;
    }
signals:
    void lastSequenceNumber(int deviceId, int sequenceNumber);
    void percentageYellowChanged();
    void percentageGreenChanged();
    void percentageRedChanged();
private:
    float m_percentageYellow = 0;
    float m_percentageRed = 0;
    float m_percentageGreen = 0;
};

#endif // MEASUREMENTSLISTMANAGER_H
