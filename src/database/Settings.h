/********************************************************************

src/database/Settings.h
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

#ifndef MYSETTINGS_H
#define MYSETTINGS_H

#include <QSettings>
#include <QDir>
#include <QDebug>
#include <QUuid>

class Settings : public QSettings
{
    Q_OBJECT
    Q_DISABLE_COPY( Settings )
    Q_PROPERTY(
            bool notFirstRun
            READ getNotFirstRun
            WRITE setNotFirstRun
            NOTIFY notFirstRunChanged)
    Q_PROPERTY(
            QString phoneNumber
            READ getPhoneNumber
            WRITE setPhoneNumber
            NOTIFY phoneNumberChanged)

public:
    explicit Settings(QObject *parent = 0);
    ~Settings();

    static QString appName;
    static QString confFolder;
    static QString confFile;

    Q_INVOKABLE QVariant get(const QString & group, const QString & key, const QVariant & defaultValue=QVariant());
    Q_INVOKABLE void     set(const QString & group, const QString & key, const QVariant & data);
public slots:
    Q_INVOKABLE void appInitialized() {};
    Q_INVOKABLE bool getNotFirstRun();
    Q_INVOKABLE void setNotFirstRun(bool notFirstRun);
    Q_INVOKABLE QString getPhoneNumber();
    Q_INVOKABLE void setPhoneNumber(QString phoneNumber);
signals:
    void notFirstRunChanged();
    void phoneNumberChanged();
    
};

#endif // MYSETTINGS_H
