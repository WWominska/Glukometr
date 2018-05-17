#include "BleParser.h"

BleParser::BleParser()
{

}

quint16 BleParser::bytesToInt(quint8 b1, quint8 b2) {
    return (b1 + (b2 << 8));
}

int BleParser::unsignedToSigned(int b, int size)
{
    if ((b & (1 << size-1)) != 0)
    {
        b = -1 * ((1 << size-1) - (b & ((1 << size-1) - 1)));
    }
    return b;
}

float BleParser::bytesToFloat(quint8 b1, quint8 b2)
{
    int mantissa = unsignedToSigned(b1 + ((b2 & 0x0F) << 8), 12);
    return (float)(mantissa);
}

QDateTime BleParser::convertTime(QByteArray data, int offset)
{
    // odczytaj 7 bajtów od podanego miejsca
    int rok = bytesToInt(data[offset], data[offset+1]); // rok mieści się w dwóch
    int miesiac = data[offset+2]; // miesiąc jest na trzecim
    int dzien = data[offset+3]; // dzień jest na czwartym
    int godziny = data[offset+4]; // godzina jest na piątym
    int minuty = data[offset+5]; // minuty są na szóstym
    int sekundy = data[offset+6]; // sekundy są na siódmym

    // stwórz obiekt daty
    QDateTime odczytanaData;

    // ustaw odczytane dane
    odczytanaData.setDate(QDate(rok, miesiac, dzien)); // ustaw datę
    odczytanaData.setTime(QTime(godziny, minuty, sekundy)); // ustaw czas

    // zwróć odczytaną datę
    return odczytanaData;
}
