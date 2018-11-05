/********************************************************************

src/database/DatabaseManager.cpp
-- accesses and manages the SQLite database.

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

#include "SqlQueryModel.h"
#include <QFile>
#include <QSqlRecord>
#include <QSqlField>

#include <QDebug>
#include <QSqlDatabase>

SqlQueryModel::SqlQueryModel(QObject *parent) :
    QSqlQueryModel(parent) {
}

void SqlQueryModel::setQuery(const QString &query, const QSqlDatabase &db) {
    if (db.isOpen()) QSqlQueryModel::setQuery(query,db);
    generateRoleNames();
}

void SqlQueryModel::setQuery(const QSqlQuery & query) {
    QSqlQueryModel::setQuery(query);
    generateRoleNames();
}

#if QT_VERSION >= 0x050000
QHash<int, QByteArray> SqlQueryModel::roleNames() const {
    QHash<int, QByteArray> roleNames;
    for( int i = 0; i < record().count(); i++) roleNames[Qt::UserRole + i + 1] = record().fieldName(i).toLatin1();
    return roleNames;
}
#endif

void SqlQueryModel::generateRoleNames() {
    QHash<int, QByteArray> roleNames;
    #if QT_VERSION < 0x050000
    for( int i = 0; i < record().count(); i++) roleNames[Qt::UserRole + i + 1] = record().fieldName(i).toAscii();
    setRoleNames(roleNames);
    #endif
}

QVariant SqlQueryModel::data(const QModelIndex &index, int role) const {
    QVariant value = QSqlQueryModel::data(index, role);
    if(role < Qt::UserRole) value = QSqlQueryModel::data(index, role);
    else {
        int columnIdx = role - Qt::UserRole - 1;
        QModelIndex modelIndex = this->index(index.row(), columnIdx);
        value = QSqlQueryModel::data(modelIndex, Qt::DisplayRole);
    }
    return value;
}
