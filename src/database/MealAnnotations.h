#ifndef MEALANNOTATIONS_H
#define MEALANNOTATIONS_H

#include <QObject>
#include "BaseListManager.h"

class MealAnnotations : public BaseListManager
{
    Q_OBJECT
public:
    MealAnnotations(DatabaseWorker* db, QObject *parent = nullptr);

    QString getTableName() const override;
    QString getCreateQuery() const override;
};

#endif // MEALANNOTATIONS_H
