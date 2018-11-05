/********************************************************************

src/database/DatabaseWorker.h
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

#ifndef DATABASEWORKER_H
#define DATABASEWORKER_H

#include <QThread>
#include <QObject>
#include <QStringList>
#include <QDebug>
#include <QSqlQuery>
#include "SqlQueryModel.h"


class DbFuture : public QObject {
    Q_OBJECT
public:
    DbFuture() {}

    const QSqlQuery& result() {
        return m_result;
    }

    void finish() {
        emit finished();
        deleteLater();
    }

    void setResult(const QSqlQuery& result) {
        m_result = result;
        finish();
    }

signals:
    void finished();
    void canceled();

private:
    QSqlQuery m_result;
};

class DatabaseWorker : public QThread
{
    Q_OBJECT
public:
    DatabaseWorker();
    
public slots:
    void setupDb();
    void executeSQL(const QString &query, const QVariantMap &params=QVariantMap(), DbFuture *f=nullptr);

private:
    QSqlDatabase db;
    QSqlQuery prepareQuery(const QString &query, const QVariantMap &params);
};

#endif // DATABASEWORKER_H
