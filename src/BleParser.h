#ifndef BLEPARSER_H
#define BLEPARSER_H
#include <QDateTime>



class BleParser
{
public:
    BleParser();

    static QDateTime convertTime(QByteArray data, int offset);

    static quint16 bytesToInt(quint8 b1, quint8 b2);
    static float bytesToFloat(quint8 b1, quint8 b2);
    static int unsignedToSigned(int b, int size);
};

#endif // BLEPARSER_H
