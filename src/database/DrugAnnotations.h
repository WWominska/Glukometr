#ifndef DRUGANNOTATIONS_H
#define DRUGANNOTATIONS_H

#include <QObject>
#include "BaseListManager.h"

class DrugAnnotations : public BaseListManager
{
    Q_OBJECT
public:
    DrugAnnotations(DatabaseWorker* db, QObject *parent = nullptr);

    QString getTableName() const override;
    QString getCreateQuery() const override;
    QString baseQuery() override;
};
#endif // DRUGANNOTATIONS_H
