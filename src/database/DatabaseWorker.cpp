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

DatabaseWorker::DatabaseWorker(QObject *parent) :
    QObject(parent)
{
    db = QSqlDatabase::database("Database");
}

QFuture<QSqlQuery> DatabaseWorker::executeSQL(const QString &query) {
    if (!db.isOpen())
        db.open();

    auto execute = [=](const QString &query) {
        QSqlQuery q(db);
        q.prepare(query);
        qDebug() << q.lastQuery();
        bool ret = q.exec();
        qDebug() << q.executedQuery();
        qDebug() << ret;
        qDebug() << q.lastError();
        q.finish();
        return q;
    };
    return QtConcurrent::run(execute, query);
}

void DatabaseWorker::executeSQL(const QString &query, SqlQueryModel *results=0) {
    if (!db.isOpen())
        db.open();

    qDebug() << query;
    results->setQuery(query, QSqlDatabase::database("Database"));
    qDebug() << results->rowCount();
}
