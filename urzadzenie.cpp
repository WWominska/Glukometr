#include <qbluetoothuuid.h>
#include "urzadzenie.h"

UrzadzenieInfo::UrzadzenieInfo(const QBluetoothDeviceInfo &info):
    QObject(), m_urzadzenie(info)
{
}

QBluetoothDeviceInfo UrzadzenieInfo::getUrzadzenie() const
{
    return m_urzadzenie;
}

QString UrzadzenieInfo::getAdres() const
{
    return m_urzadzenie.address().toString();
}

void UrzadzenieInfo::setUrzadzenie(const QBluetoothDeviceInfo &urzadzenie)
{
    m_urzadzenie = urzadzenie;
    emit urzadzenieChanged();
}
