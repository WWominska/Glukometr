#include "BaseListManager.h"


BaseListManager::BaseListManager(DatabaseWorker *db, QObject *) : m_db(db)
{
    m_model = new SqlQueryModel();
    connect(m_model, &SqlQueryModel::modelReset, this, [=](){
        emit modelChanged();
    });
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

void BaseListManager::get(bool reset)
{
    // shorthand for get(QVariantMap(), reset=true)
    get(QVariantMap(), reset);
}

void BaseListManager::get(QVariantMap where, bool reset) {
    QString query = baseQuery().arg(getTableName());

    if (where.isEmpty() && !reset)
        where = lastFilter;
    else lastFilter = where;

    if (!where.isEmpty())
        query = QString("%1 WHERE %2").arg(query, keysToBindings(where));

    DbFuture *f = new DbFuture();
    connect(f, &DbFuture::finished, [=]() {
        m_model->setQuery(f->result());
    });
    m_db->executeSQL(query, where, f);
}

void BaseListManager::update(
        QVariantMap where, QVariantMap fields,
        bool refresh)
{
    QVariantMap params;
    QString query = QString("UPDATE %1 SET %2%3").arg(
        getTableName(),
        keysToBindings(fields, &params, "f_", ", "),
        where.isEmpty() ? "" : " WHERE " + keysToBindings(where, &params, "w_")
    );

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

    QStringList bindings;
    for (auto i: data.keys()) {
        bindings.push_back(":" + i);
    }
    QString query = QString("INSERT INTO %1 (%2) VALUES (%3)").arg(
        getTableName(),
        data.keys().join(", "),
        bindings.join(", ")
    );
    this->executeQuery(query, [=](QSqlQuery) {
        get();
    }, data);
}

void BaseListManager::remove(int id) {
    remove({{getTableName() + "_id", id}});
}

void BaseListManager::remove(QVariantMap where) {
    QString query = QString("DELETE FROM %1%2").arg(
        getTableName(),
        where.isEmpty() ? "" : " WHERE " + keysToBindings(where)
    );

    this->executeQuery(query, [=](QSqlQuery) {
        get();
    }, where);
}

SqlQueryModel* BaseListManager::getModel() {
    // create table if it wasn't created when someone wants to use
    // our model
    if (!m_tableCreated)
        initializeTable();

    // return a pointer to model
    return m_model;
}

QString BaseListManager::keysToBindings(
        const QVariantMap &fields,
        QVariantMap *params,
        const QString &prefix,
        const QString &separator)
{
    QStringList query;
    for (QVariantMap::const_iterator iter = fields.begin(); iter != fields.end(); ++iter) {
        QString binding = QString("%1%2").arg(prefix, iter.key());
        query.push_back(QString("%1 = :%2").arg(iter.key(), binding));
        if (params)
            params->operator [](binding) = iter.value();
    }
    return query.join(separator);
}

void BaseListManager::appInitialized() {
    this->initializeTable();
    this->get();
}
