#ifndef TEXTANNOTATIONS_H
#define TEXTANNOTATIONS_H


#include <QObject>
#include "BaseListManager.h"

class TextAnnotations : public BaseListManager
{
    Q_OBJECT
public:
    TextAnnotations(DatabaseWorker* db, QObject *parent = nullptr);

    QString getTableName() const override;
    QString getCreateQuery() const override;
};

#endif // TEXTANNOTATIONS_H
