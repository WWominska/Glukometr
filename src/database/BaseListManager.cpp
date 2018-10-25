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
        m_db->executeSQL(getCreateQuery(), f);
    }
}

void BaseListManager::slotTableCreated() {
    m_tableCreated = true;
    emit tableCreated();
    get();
}

void BaseListManager::executeQuery(const QString &query, const std::function<void(QSqlQuery)> &callback) {
    if (m_db) {
        DbFuture *f = new DbFuture();
        connect(f, &DbFuture::finished,
         [=]() {
            callback(f->result());
         });
        m_db->executeSQL(query, f);
    }
}

QString BaseListManager::baseQuery() {
    return "SELECT * FROM " + getTableName();
}

void BaseListManager::get() {
    m_db->executeSQL(baseQuery(), m_model);
}

void BaseListManager::update(
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
    this->executeQuery(query, [=](QSqlQuery) {
        if (refresh)
            get();
    });
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

    this->executeQuery(query, [=](QSqlQuery) {
        get();
    });
}

void BaseListManager::remove(int id) {
    this->executeQuery("DELETE FROM " + getTableName() + " WHERE " + getTableName() + "_id = " + QString::number(id), [=](QSqlQuery) {
        get();
    });
}

SqlQueryModel* BaseListManager::getModel() {
    // create table if it wasn't created when someone wants to use
    // our model
    if (!m_tableCreated)
        initializeTable();

    // return a pointer to model
    return m_model;
}
