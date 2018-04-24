#ifndef URZADZENIE_H
#define URZADZENIE_H

#include <QString>
#include <QObject>
#include <qbluetoothdeviceinfo.h>
#include <qbluetoothaddress.h>

class UrzadzenieInfo: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString urzadzenieNazwa READ getNazwa NOTIFY urzadzenieChanged)
    Q_PROPERTY(QString urzadzenieAdres READ getAdres NOTIFY urzadzenieChanged)
public:
    UrzadzenieInfo(const QBluetoothDeviceInfo &urzadzdenie);
    void setUrzadzenie(const QBluetoothDeviceInfo &urzadzenie);
    QString getNazwa() const { return m_urzadzenie.name(); }
    QString getAdres() const;
    QBluetoothDeviceInfo getUrzadzenie() const;

signals:
    void urzadzenieChanged();

private:
    QBluetoothDeviceInfo m_urzadzenie;
};

#endif // URZADZENIE_H
