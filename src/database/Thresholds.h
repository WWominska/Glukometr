#ifndef THRESHOLDS_H
#define THRESHOLDS_H

#include <QObject>
#include <QDebug>
#include <QPair>
#include <QSqlRecord>
#include "BaseListManager.h"

class Thresholds: public BaseListManager
{
    Q_OBJECT
public:
    explicit Thresholds(DatabaseWorker* db, QObject *parent = nullptr);

    QString getTableName() const override;
    QString getCreateQuery() const override;

public slots:
    void setDefaults();
    QString evaluateMeasurement(int value, int meal);

private slots:
    void updateCache();

private:
    QMap<int, QPair<int, int>> m_thresholdCache;
};

#endif // THRESHOLDS_H
