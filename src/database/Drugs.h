#ifndef DRUGS_H
#define DRUGS_H

#include <QObject>
#include "BaseListManager.h"


class Drugs : public BaseListManager
{
    Q_OBJECT
public:
    explicit Drugs(DatabaseWorker* db, QObject *parent = nullptr);

    QString getTableName() const override;
    QString getCreateQuery() const override;

public slots:
    void setDefaults();
};

#endif // DRUGS_H
