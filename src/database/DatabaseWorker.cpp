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

void DatabaseWorker::executeSQL(const QString &query, DbFuture *f) {
    setupDb();
    QSqlQuery q(db);
    q.prepare(query);
    bool ret = q.exec();
    if (!ret) {
        qDebug() << "DB Error: " << q.lastError();
        qDebug() << "while executing query: " << q.executedQuery();
    }
    q.finish();
    if (f)
        f->setResult(q);
}

void DatabaseWorker::executeSQL(const QString &query, SqlQueryModel *model, DbFuture *f) {
    setupDb();
    qDebug() << "called executeSQL" << query;
    if (f) {
        connect(model, &SqlQueryModel::modelReset, [=]() {
            f->finish();
        });
    }
    model->setQuery(query, db);
}

void DatabaseWorker::setupDb() {
    if (db.databaseName().isEmpty()) {
        db = QSqlDatabase::addDatabase("QSQLITE", "Database");
        db.setDatabaseName("com.glukometr.db");
    }

    if (!db.isOpen())
        db.open();
}
