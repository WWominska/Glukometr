#ifndef BASELISTMANAGER_H
#define BASELISTMANAGER_H

#include <QObject>
#include <QDebug>
#include <QFuture>
#include <QFutureWatcher>
#include "DatabaseWorker.h"

class BaseListManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(
        SqlQueryModel* query
        READ getQuery
        NOTIFY queryChanged
    )
public:
    explicit BaseListManager(
            DatabaseWorker *db,
            QObject *parent = nullptr) : m_db(db) {
        m_query = new SqlQueryModel();
    }
    virtual QString getTableName() const { return ""; }
    virtual QString getCreateQuery() const { return ""; }

    void initializeTable() {
        if (m_db) {
            QFuture<QSqlQuery> f = m_db->executeSQL(getCreateQuery());
            QFutureWatcher<QSqlQuery> *watcher = new QFutureWatcher<QSqlQuery>();
            connect(watcher, &QFutureWatcher<QSqlQuery>::finished,
             [=]() {
                QSqlQuery result = f.result();
                qDebug() << result.lastError();
                qDebug() << result.numRowsAffected();
             });
            watcher->setFuture(f);
        }
    }

    void executeQuery(const QString &query, const std::function<void(QSqlQuery)> &callback) {
        if (m_db) {
            QFuture<QSqlQuery> f = m_db->executeSQL(query);
            QFutureWatcher<QSqlQuery> *watcher = new QFutureWatcher<QSqlQuery>();
            connect(watcher, &QFutureWatcher<QSqlQuery>::finished,
             [=]() {
                callback(f.result());
             });
            watcher->setFuture(f);
        }
    }

    virtual QString baseQuery() {
        return "SELECT * FROM " + getTableName();
    }

    Q_INVOKABLE void getFromDB() {
        m_db->executeSQL(baseQuery(), m_query);
    }

    Q_INVOKABLE void update(
            QVariantMap where, QVariantMap fields, bool refresh) {
        QString query = "UPDATE " + getTableName() + " SET ";
        for (QVariantMap::const_iterator iter = fields.begin(); iter != fields.end(); ++iter) {
            query += iter.key() + " = " + iter.value().toString();
            if (iter != fields.end() - 1)
                query += " AND ";
        }
        query += " WHERE ";
        for (QVariantMap::const_iterator iter = where.begin(); iter != where.end(); ++iter) {
            query += iter.key() + " = " + iter.value().toString();
            if (iter != where.end() - 1)
                query += " AND ";
        }
        this->executeQuery(query, [=](QSqlQuery result) {
            if (refresh)
                getFromDB();
        });
    }

    virtual QVariantMap getDefaults() {
        return QVariantMap();
    }

    Q_INVOKABLE void add(QVariantMap data) {
        QVariantMap defaults = getDefaults();
        for (QVariantMap::const_iterator iter = defaults.begin(); iter != defaults.end(); ++iter) {
            if (!data.contains(iter.key()))
                data[iter.key()] = iter.value();
        }

        QString query = "INSERT INTO " + getTableName() + " ";
        QString keys = "(", values = "(";
        for (QVariantMap::const_iterator iter = data.begin(); iter != data.end(); ++iter) {
            keys += iter.key();
            values += iter.value().toString();
            if (iter != data.end() - 1) {
                keys += ", ";
                values += ", ";
            }
        }
        keys += ")";
        values += ")";
        query += keys + " VALUES " + values;

        this->executeQuery(query, [=](QSqlQuery result) {
            getFromDB();
        });
    }
    Q_INVOKABLE void remove(int id) {
        this->executeQuery("DELETE FROM " + getTableName() + " WHERE " + getTableName() + "_id = " + QString::number(id), [=](QSqlQuery result) {
            getFromDB();
        });
    }

signals:
    void queryChanged();

public slots:

protected:
    SqlQueryModel* m_query;
    DatabaseWorker* m_db;

private:
    SqlQueryModel* getQuery() {
        return m_query;
    }
};

#endif // BASELISTMANAGER_H
