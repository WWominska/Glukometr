/********************************************************************

src/database/Settings.cpp
-- holds settings of the app and accounts details

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

#include "Settings.h"

#include <QDir>
#include <QStandardPaths>
#include <QDebug>

#ifdef Q_OS_BLACKBERRY
QString Settings::confFile = QDir::currentPath() + QDir::separator() + "data/Settings.conf";
#elif defined(Q_OS_SAILFISH) | defined(Q_OS_WIN)
QString Settings::confFile = QDir(QStandardPaths::writableLocation(QStandardPaths::ConfigLocation))
        .filePath("harbour-glukometr") + "/Settings.conf";
#else
QString Settings::confFile = QDir::currentPath() + QDir::separator() + "Settings.conf";
#endif

Settings::Settings(QObject *parent) : QSettings(Settings::confFile, QSettings::IniFormat, parent) {
  qDebug() << confFile;
}

Settings::~Settings() {
    // sync on destruction
    this->sync();
}

/*************************** (generic settings) **************************/
QVariant Settings::get(const QString & group, const QString & key, const QVariant & defaultValue) {
  beginGroup(group);
  QVariant ret = value(key, defaultValue);
  endGroup();
  return ret;
}
void Settings::set(const QString & group, const QString & key, const QVariant & data) {
  beginGroup(group);
  setValue(key, data);
  endGroup();
  this->sync();
}


// settings
bool Settings::getNotFirstRun() { return get("conf", "NotFirstRun", false).toBool(); }
void Settings::setNotFirstRun(bool notFirstRun) {
    set("conf", "NotFirstRun", notFirstRun);
    emit notFirstRunChanged();
}

QString Settings::getPhoneNumber() { return get("conf", "PhoneNumber", "").toString(); }
void Settings::setPhoneNumber(QString phoneNumber) {
    set("conf", "PhoneNumber", phoneNumber);
    emit phoneNumberChanged();
}
