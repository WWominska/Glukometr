#include "BaseListManager.h"


BaseListManager::BaseListManager(DatabaseWorker *db, QObject *) : m_db(db)
{
    m_model = new SqlQueryModel();
}

QString BaseListManager::getTableName() const {
    return "";
}
QString BaseListManager::getCreateQuery() const {
    return "";
}

void BaseListManager::initializeTable() {
    if (m_db) {
        DbFuture *f = new DbFuture();
        connect(f, &DbFuture::finished, this, &BaseListManager::slotTableCreated);
        connect(f, &DbFuture::canceled, this, &BaseListManager::slotTableFailed);
        m_db->executeSQL(getCreateQuery(), QVariantMap(), f);
    }
}

void BaseListManager::slotTableCreated() {
    m_tableCreated = true;
    emit tableCreated();
    get();
}

void BaseListManager::slotTableFailed() {
    // assume it's created for now
    // TODO: actually check what happened
    m_tableCreated = true;
    get();
}

void BaseListManager::executeQuery(
        const QString &query,
        const std::function<void(QSqlQuery)> &callback,
        const QVariantMap &params)
{
    if (m_db) {
        DbFuture *f = new DbFuture();
        connect(f, &DbFuture::finished,
         [=]() {
            callback(f->result());
         });
        m_db->executeSQL(query, params, f);
    }
}

QString BaseListManager::baseQuery() {
    return "SELECT * FROM %1";
}

void BaseListManager::get() {
    DbFuture *f = new DbFuture();
    connect(f, &DbFuture::finished, [=]() {
        m_model->setQuery(f->result());
    });
    m_db->executeSQL(baseQuery().arg(getTableName()), QVariantMap(), f);
}

void BaseListManager::update(
        QVariantMap where, QVariantMap fields,
        bool refresh)
{
    QVariantMap params;
    QString query = QString("UPDATE %1 SET ").arg(getTableName());

    for (QVariantMap::const_iterator iter = fields.begin(); iter != fields.end(); ++iter) {
        query += QString("%1 = :f_%1").arg(iter.key());
        params["f_" + iter.key()] = iter.value();
        if (iter != fields.end() - 1)
            query += " AND ";
    }

    query += " WHERE ";
    for (QVariantMap::const_iterator iter = where.begin(); iter != where.end(); ++iter) {
        query += QString("%1 = :w_%1").arg(iter.key());
        params["w_" + iter.key()] = iter.value();
        if (iter != where.end() - 1)
            query += " AND ";
    }
    this->executeQuery(query, [=](QSqlQuery) {
        if (refresh)
            get();
    }, params);
}

QVariantMap BaseListManager::getDefaults() {
    return QVariantMap();
}

void BaseListManager::add(QVariantMap data) {
    QVariantMap defaults = getDefaults();
    for (QVariantMap::const_iterator iter = defaults.begin(); iter != defaults.end(); ++iter) {
        if (!data.contains(iter.key()))
            data[iter.key()] = iter.value();
    }

    QVariantMap params;
    QString query = QString("INSERT INTO %1 ").arg(getTableName());
    QString keys = "(", values = "(";
    for (QVariantMap::const_iterator iter = data.begin(); iter != data.end(); ++iter) {
        keys += iter.key();
        values += ":p_" + iter.key();
        params["p_" + iter.key()] = iter.value();
        if (iter != data.end() - 1) {
            keys += ", ";
            values += ", ";
        }
    }
    keys += ")";
    values += ")";
    query += keys + " VALUES " + values;

    this->executeQuery(query, [=](QSqlQuery) {
        get();
    }, params);
}

void BaseListManager::remove(int id) {
    remove({{getTableName() + "_id", id}});
}

void BaseListManager::remove(QVariantMap where) {
    QVariantMap params;
    QString query = QString("DELETE FROM %1 WHERE ").arg(getTableName());

    for (QVariantMap::const_iterator iter = where.begin(); iter != where.end(); ++iter) {
        query += QString("%1 = :%1").arg(iter.key());
        params[iter.key()] = iter.value();
        if (iter != where.end() - 1)
            query += " AND ";
    }

    this->executeQuery(query, [=](QSqlQuery) {
        get();
    }, params);
}

SqlQueryModel* BaseListManager::getModel() {
    // create table if it wasn't created when someone wants to use
    // our model
    if (!m_tableCreated)
        initializeTable();

    // return a pointer to model
    return m_model;
}
