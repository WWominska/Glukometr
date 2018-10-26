/********************************************************************

src/database/DatabaseWorker.cpp
-- class designed to enable access DatabaseManager in a threaded way

Copyright (c) 2013 Maciej Janiszewski

This file is part of Lightbulb.

Lightbulb is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

*********************************************************************/

#include "DatabaseWorker.h"

DatabaseWorker::DatabaseWorker() {}

void DatabaseWorker::executeSQL(
        const QString &query,
        const QVariantMap &params,
        DbFuture *f) {
    QSqlQuery q = prepareQuery(query, params);
    bool ret = q.exec(); // execute query

    // show error when failed
    if (!ret) {
        qDebug() << "DB Error: " << q.lastError();
        qDebug() << "while executing query: " << q.executedQuery() << q.boundValues();
        qDebug() << "Provided query:" << query << "with params " << params;
    }

    // handle promise
    if (f) {
        if (ret)
            f->setResult(q);
        else f->canceled();
    }
}

void DatabaseWorker::setupDb() {
    if (db.databaseName().isEmpty()) {
        db = QSqlDatabase::addDatabase("QSQLITE", "Database");
        db.setDatabaseName("com.glukometr.db");
    }

    if (!db.isOpen())
        db.open();
}

QSqlQuery DatabaseWorker::prepareQuery(const QString& query, const QVariantMap& params) {
    // prepare DB
    setupDb();
    QSqlQuery q = QSqlQuery(db);
    q.prepare(query);

    // bind parameters
    for (QVariantMap::const_iterator iter = params.begin(); iter != params.end(); ++iter)
        q.bindValue(":" + iter.key(), iter.value());

    // return query
    return q;
}
