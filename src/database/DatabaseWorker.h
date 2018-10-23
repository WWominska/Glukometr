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

#include <QObject>
#include <QStringList>
#include <QFuture>
#include <QDebug>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QtConcurrent/QtConcurrent>
#include "SqlQueryModel.h"

class DatabaseWorker : public QObject
{
    Q_OBJECT
public:
    explicit DatabaseWorker(QObject *parent = 0);
    
public slots:
    QFuture<QSqlQuery> executeSQL(const QString &query);
    void executeSQL(const QString &query, SqlQueryModel* results);

private:
    QSqlDatabase db;

};

#endif // DATABASEWORKER_H
