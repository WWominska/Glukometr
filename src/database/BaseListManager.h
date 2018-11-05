#ifndef BASELISTMANAGER_H
#define BASELISTMANAGER_H

#include <QObject>
#include <QDebug>
#include <QSqlRecord>
#include "DatabaseWorker.h"

class BaseListManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(
        SqlQueryModel* model
        READ getModel
        NOTIFY modelChanged
    )
public:
    explicit BaseListManager(
            DatabaseWorker *db,
            QObject *);
    virtual QString getTableName() const;
    virtual QString getCreateQuery() const;
    void initializeTable();

    void executeQuery(const QString &query, const std::function<void(QSqlQuery)> &callback, const QVariantMap &params=QVariantMap());
    virtual QString baseQuery();
    Q_INVOKABLE void get(bool reset=false);
    Q_INVOKABLE void get(QVariantMap where, bool reset=false);

    Q_INVOKABLE void update(QVariantMap where, QVariantMap fields, bool refresh=true);
    virtual QVariantMap getDefaults();

    Q_INVOKABLE void add(QVariantMap data);
    Q_INVOKABLE void remove(int id);
    Q_INVOKABLE void remove(QVariantMap where=QVariantMap());

    bool m_tableCreated = false;

signals:
    void modelChanged();
    void tableCreated();

public slots:
    void slotTableCreated();
    void slotTableFailed();
    void appInitialized();

protected:
    SqlQueryModel* m_model;
    DatabaseWorker* m_db;
    QVariantMap lastFilter;

private:
    SqlQueryModel* getModel();
    QString keysToBindings(const QVariantMap &fields,
            QVariantMap *params=nullptr,
            const QString &prefix="",
            const QString &separator=" AND ");
};

#endif // BASELISTMANAGER_H
