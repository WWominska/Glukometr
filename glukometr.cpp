#include "glukometr.h"
#include <QDataStream>

#include <QtEndian>
#include <QtMath>

quint16 Glukometr::bytesToInt(quint8 b1, quint8 b2)
{
    return (b1 + (b2 << 8));
}

int Glukometr::unsignedToSigned(int b, int size)
{
    if ((b & (1 << size-1)) != 0)
    {
        b = -1 * ((1 << size-1) - (b & ((1 << size-1) - 1)));
    }
    return b;
}

float Glukometr::bytesToFloat(quint8 b1, quint8 b2)
{
    int mantissa = unsignedToSigned(b1 + ((b2 & 0x0F) << 8), 12);
    return (float)(mantissa);
}

//QBiteArray - funkcj dostarczająca użytkownikowi szyk bajtów
QDateTime Glukometr::convertTime(QByteArray data, int offset)
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


Historia* Glukometr::parseGlucoseMeasurementData(QByteArray data)
{
    // zaczynamy od zerowego bajtu
    int offset = 0;

    // 1 bajt zawiera flagi, szaczytaj i przejdź do następnego
    quint8 flags = data[offset];
    offset += 1;

    // odczytanie kolejnych flag
    bool timeOffsetPresent = (flags & 0x01) > 0;
    bool typeAndLocationPresent = (flags & 0x02) > 0;
    QString jednostka = (flags & 0x04) > 0 ? "mmol/l" : "mg/dl";

    quint16 sequenceNumber = bytesToInt(data[offset], data[offset+1]); //przechowuje liczbe przez to że jest qu tzn że nie ma żadnego znaku a 16 to długość
    qDebug() << sequenceNumber;

    offset += 2;

    // odczytaj datę i przejdź o 7 bajtów dalej (tyle zajmuje)
    QDateTime dataPomiaru = this->convertTime(data, offset);
    offset += 7;

    // offset czasowy
    quint16 timeOffset = 0;

    // jeśli dano offset czasowy, odczytaj
    if (timeOffsetPresent)
    {
        timeOffset = bytesToInt(data[offset], data[offset+1]); // offset zajmuje 2 bajty
        // przejdź o 2 bajty dalej
        offset += 2;
    }

    float glucoseConcentration = 0;
    // jeśli jest typ miejsce pomiaru
    if (typeAndLocationPresent)
    {
        glucoseConcentration = this->bytesToFloat(data[offset], data[offset+1]);
    }

    Historia* pomiary = new Historia (glucoseConcentration, dataPomiaru);
    emit newMeasurement(glucoseConcentration, dataPomiaru, 1, sequenceNumber);

    return pomiary;
}

void Glukometr::glukozaPomiarKontekst(QByteArray data)
{
    // na podstawie https://www.bluetooth.com/specifications/gatt/viewer?attributeXmlFile=org.bluetooth.characteristic.glucose_measurement_context.xml

    // zaczynamy od zerowego bajtu
    int offset = 0;

    // 1 bajt zawiera flagi, szaczytaj i przejdź do następnego
    quint8 flags = data[offset];
    offset += 1;

    // wyciagnij informacje z flag
    bool carbohydratePresent = (flags & 0x01) > 0;
    bool mealPresent = (flags & 0x02) > 0;
    bool testerHealthPresent = (flags & 0x04) > 0;
    bool exercisePresent = (flags & 0x08) > 0;
    bool medicationPresent = (flags & 0x10) > 0;
    QString medicationUnit = (flags & 0x20) > 0 ? "litrow" : "kilogramow";
    bool hbA1cPresent = (flags & 0x40) > 0;
    bool moreFlagsPresent = (flags & 0x80) > 0;

    int carbohydrate_id, meal, tester, health, exerciseDuration, exerciseIntensity, medicationId;
    float carbohydrate_units, medicationQuantity, HbA1c;

    // numer sekwencji
    quint16 sequenceNumber = bytesToInt(data[offset], data[offset+1]); //przechowuje liczbe przez to że jest qu tzn że nie ma żadnego znaku a 16 to długość
    offset += 2;

    if (moreFlagsPresent) // sprawdzamy flagi czy sa (może ich nie być)
        offset += 1;

    if (carbohydratePresent)
    {
        // 1 = sniadanie
        // 2 = lunch
        // 3 = obiad
        // 4 = przekaska (?)
        // 5 = napoj
        // 6 = kolacja
        // 7 = brunch
        carbohydrate_id = data[offset];
        // ilosc weglowodanow do spozycia (?)
        carbohydrate_units = this->bytesToFloat(data[offset+1], data[offset+2]);
        // przechodzimy o 3 bajty dalej
        offset += 3;
    }

    if (mealPresent) {
        // 1 = przed jedzeniem
        // 2 = po jedzeniu
        // 3 = na czczo
        // 4 = casual, nie wiem jak to sensownie przetłumaczyć ale przekąski, napoje
        // 5 = przed snem (bedtime)
        meal = data[offset];
        offset += 1;
    }

    if (testerHealthPresent)
    {
        // nie wiem co to jest i po co, ale tester mowi czy ktos sam sprawdza czy jak
        // a to drugie czy ktos jest bardzo chory czy nie (?)
        // sprawdz dokumentacje
        int testerHealth = data[offset];
        tester = (testerHealth & 0xF0) >> 4;
        health = (testerHealth & 0x0F);
        offset += 1;
    }

    if (exercisePresent)
    {
        exerciseDuration = bytesToInt(data[offset], data[offset+1]); // dlugosc cwiczen (?) zajmuje 2 bajty
        exerciseIntensity = data[offset+2]; // intensywnosc cwiczen
        offset += 3;
    }

    if (medicationPresent)
    {
        // pod medcationId sa takie liczby,
        // 1 - Rapid acting insulin
        // 2 - Short acting insulin
        // 3 - Intermediate acting insulin
        // 4 - Long acting insulin
        // 5 - Pre-mixed insulin
        medicationId = data[offset];
        // ilosc lekow do wziecia (?)
        medicationQuantity = bytesToFloat(data[offset+1], data[offset+2]);
        offset += 3;
    }

    if (hbA1cPresent)
        HbA1c = bytesToFloat(data[offset], data[offset+1]);

    emit mealChanged(1, sequenceNumber, meal);
}

//QBluetoothDeviceInfo - Zbiera i dostarcza informację na temat urządzenia Bluetooth (nazwa, adres, klasa)
//QBluetoothDeviceDiscoveryAgent - odszukuje pobliskie urządzenia Bluetooth
Glukometr::Glukometr():
    m_currentUrzadzenie(QBluetoothDeviceInfo()), foundGlukometrService(false),
    m_control(0), m_service(0)
{
    m_urzadzenieDiscoveryAgent = new QBluetoothDeviceDiscoveryAgent(this);//klasa pozwalajaca wykrywac urzadzenia

    connect(m_urzadzenieDiscoveryAgent, SIGNAL(deviceDiscovered(const QBluetoothDeviceInfo&)),
            this, SLOT(addUrzadzenie(const QBluetoothDeviceInfo&)));//sygnał się włączy gdy znajdzie urządzenie
    connect(m_urzadzenieDiscoveryAgent, SIGNAL(finished()), this, SLOT(scanFinished()));//włączy się funkcja gdy skończy szukać urzadzen

    enable_indication = QByteArray::fromHex("0200");
    enable_notification = QByteArray::fromHex("0100");//stałe zgapione ze specyfikacji

    // assume there is nothing in DB until said otherwise
    lastSequenceNumber = 0;
}

Glukometr::~Glukometr()
{
    qDeleteAll(m_urzadzenia);
    m_urzadzenia.clear();
}

void Glukometr::urzadzenieSearch() //funkcja włączająca szukanie urządzeń
{
    qDeleteAll(m_urzadzenia); //usuwa urządzenia z listy jeśli są (czyści pamięć)
    m_urzadzenia.clear(); //robi to samo co wyżej tylko z listy
    emit nazwaChanged();
    m_urzadzenieDiscoveryAgent->start(); //rozpoczyna szukanie nowego urządzenia
    setWiadomosc("Skanowanie urządzeń");
}

void Glukometr::addUrzadzenie(const QBluetoothDeviceInfo &urzadzenie) //dla każdego znalezionego urządzenia wykona się ta funkcja
{
    if (urzadzenie.coreConfigurations() & QBluetoothDeviceInfo::LowEnergyCoreConfiguration) //sprawdza czy urządzenie żre mało prądu
    {
        UrzadzenieInfo *dev = new UrzadzenieInfo(urzadzenie); //tworzy wskaźnik na obiekt przymający informację o urządzeniu
        m_urzadzenia.append(dev); //dodaje urządzenie do listy urządzeń
        setWiadomosc("Znaleziono urządzenie");
    }
}

void Glukometr::scanFinished()//włączy się jak skończy skanować
{
    if (m_urzadzenia.size() == 0)//sprawdza czy nie ma urządzeń
        setWiadomosc("Nie znaleziono urządzeń");
    Q_EMIT nazwaChanged(); // emituje sygnał że zmieniła się lista urządzeń
}

void Glukometr::setWiadomosc(QString wiadomosc) //funkcja do wyświetlania komunikatów
{
    m_info = wiadomosc;
    Q_EMIT wiadomoscChanged();
}

QString Glukometr::wiadomosc() const //funkcja zwracająca wiadomość
{
    return m_info;
}

QVariant Glukometr::nazwa()
{
    return QVariant::fromValue(m_urzadzenia); //lista urządzeń
}

QVariant Glukometr::pomiary()
{
    return QVariant::fromValue(m_pomiary); //lista urządzeń
}

//QBluetoothUuid - generuje adres Uuid dla każdej usługi Bluetooth
//QLowEnergyController - daje dostęp do urządzeń w sieci Bluetooth i jest punktem wejścia do tworzenia sieci Buetooth

void Glukometr::connectToService(const QString &adres) //łączy się z urządzeniem i przyjmuje jako parametr jego adres
{
    m_measurements.clear(); //czyści liste pomiarów
    bool urzadzenieFound = false;
    for (int i = 0; i < m_urzadzenia.size(); i++) //przechodzi po całej liście urządzeń
    {
        if (((UrzadzenieInfo*)m_urzadzenia.at(i))->getAdres() == adres ) //i wybiera tylko taki który ma taki sam adres jaki przyjmuje w parametrze ta funkcja
        {
            m_currentUrzadzenie.setUrzadzenie(((UrzadzenieInfo*)m_urzadzenia.at(i))->getUrzadzenie()); //jeśli tak to ustawia urządzenie na to szukanie
            setWiadomosc("Trwa łączenie z urządzeniem");
            urzadzenieFound = true; //zmienna jest tylko po to żeby program się nie wywalił
            break;
        }
    }

    if (m_control)
    {
        m_control->disconnectFromDevice();// jeśli jest połączony to ma się z nim rozłączyć
        delete m_control;
        m_control = 0;
    }

    m_control = new QLowEnergyController(m_currentUrzadzenie.getUrzadzenie(), this); //tworzy obiekt pozwalający zrobić cokolwiek z urządzeniem

    connect(m_control, SIGNAL(serviceDiscovered(QBluetoothUuid)),
            this, SLOT(serviceDiscovered(QBluetoothUuid)));//odpali się gdy zostanie znaleziona usługa
    connect(m_control, SIGNAL(discoveryFinished()),
            this, SLOT(serviceScanDone()));//skończyło się skanowanie tych usług
    connect(m_control, SIGNAL(error(QLowEnergyController::Error)),
            this, SLOT(controllerError(QLowEnergyController::Error))); //włącza się jak wystąpi jakiś błąd
    connect(m_control, SIGNAL(connected()),
            this, SLOT(urzadzenieConnected()));//połączyło się z urządzeniem
    connect(m_control, SIGNAL(disconnected()),
            this, SLOT(urzadzenieDisconnected()));//rozłączyło się z urządzeniem

    m_control->connectToDevice();//łączy się z urządzenim
}

void Glukometr::urzadzenieConnected()
{
    m_control->discoverServices(); //szuka usług
}

void Glukometr::urzadzenieDisconnected()
{
    setWiadomosc("Rozłączono urządzenie");
}

void Glukometr::serviceDiscovered(const QBluetoothUuid &gatt)
{
    qDebug() << gatt;
    if (gatt == QBluetoothUuid(QBluetoothUuid::Glucose))
    {
        foundGlukometrService = true; //funkcja sprawdzająca czy urządzenie jest glukometrem
    }
}

//QLowEnergyCharacteristic - podaje informację o charakterystyce (nt nazwy, Uuid, wartość własności identyfikatory)
//QLowEnergyDescriptor - dostarcza informację o charakterystycę
void Glukometr::serviceScanDone() //konczy szukać usług
{
    delete m_service; //usunwa usługę z pamięci (była połączona)
    m_service = 0; //zeruje wskaźnik żeby nie pokazywał na miejsce w pamięcii
    if (foundGlukometrService) //znajduje glukometr
    {
        setWiadomosc("Trwa parowanie");
        m_service = m_control->createServiceObject(//łącze się do usługi, tworze wskaźnik na obiekt usługi
                    QBluetoothUuid(QBluetoothUuid::Glucose), this);
    }

    if (!m_service) //kiedy nie znajdzie glukometru
    {
        setWiadomosc("Nie znaleziono glukometru.");
        return;
    }

    connect(m_service, SIGNAL(stateChanged(QLowEnergyService::ServiceState)),
            this, SLOT(serviceStateChanged(QLowEnergyService::ServiceState)));//włączy się jak znajdzie informację o usłudze
    connect(m_service, SIGNAL(characteristicChanged(QLowEnergyCharacteristic,QByteArray)),
            this, SLOT(updateGlukometrValue(QLowEnergyCharacteristic,QByteArray)));//włączy się jak dostanie pomiar do tablicy bitów
    connect(m_service, SIGNAL(error(QLowEnergyService::ServiceError)),
            this, SLOT(serviceError(QLowEnergyService::ServiceError)));
    connect(m_service, SIGNAL(descriptorWritten(QLowEnergyDescriptor,QByteArray)), //sygnał został zapisany do skryptu (chce wiedzieć czy on wie że powinien coś wysłać)
            this, SLOT(confirmedDescriptorWrite(QLowEnergyDescriptor,QByteArray)));

    m_service->discoverDetails();//każe mu znaleźć info o usłudze
}

void Glukometr::disconnectService()
{
    foundGlukometrService = false;

    //disable notifications before disconnecting
    if (m_notificationDesc.isValid() && m_service
            && m_notificationDesc.value() == enable_notification)
    {
        m_service->writeDescriptor(m_notificationDesc, QByteArray::fromHex("0000"));
    }

    else
    {
        m_control->disconnectFromDevice();
        delete m_service;
        m_service = 0;
    }
}

void Glukometr::controllerError(QLowEnergyController::Error error)
{
    setWiadomosc("Nie można połączyć się z urządzeniem");
    qWarning() << "Controller Error:" << error;
}

void Glukometr::serviceStateChanged(QLowEnergyService::ServiceState s)
{
    switch (s)
    {
    case QLowEnergyService::ServiceDiscovered://wie że usługa została znaleziona
    {
        ostatni=true;
        QLowEnergyCharacteristic glChar; //tworzy obiekt, który będzie trzymał informację i parametry
        // subskrybcja Glucose Measurement (pomiary)
        glChar = m_service->characteristic(QBluetoothUuid(QBluetoothUuid::GlucoseMeasurement)); //pobiera informację o charakterystyce pomiarów
        if (!glChar.isValid()) //jeśli nie może pobrać charakterystyki to wywarzuca komunikat
        {
            setWiadomosc("Nie pobrano danych");
            break;
        }

        else // zasubskrybuj
        {
            m_service->writeDescriptor(glChar.descriptor(QBluetoothUuid(QBluetoothUuid::ClientCharacteristicConfiguration)),
                                       enable_notification); //jak dostanie pomiar to dostane informację (przechowuje informację co ma zrobić z pomiarami)
        }

        // Glucose Measurement Context (dodatkowe info o pomiarach)
        glChar = m_service->characteristic(QBluetoothUuid(QBluetoothUuid::GlucoseMeasurementContext));//robi to samo tylko dla innego konteksu
        if (!glChar.isValid())
        {
            setWiadomosc("Nie pobrano danych");
            break;
        }

        else
        {
            // zasubskrybuj
            m_service->writeDescriptor(glChar.descriptor(QBluetoothUuid(QBluetoothUuid::ClientCharacteristicConfiguration)),enable_notification);
        }

        // Record Access Control Point (książeczka) - funkcja używana w usługach (zarządzanie danymi pacjęta)
        glChar = m_service->characteristic(QBluetoothUuid(QBluetoothUuid::RecordAccessControlPoint));
        if (!glChar.isValid())
        {
            setWiadomosc("Nie pobrano danych");
            break;
        }

        else
        {
            // zasubskrybuj
            m_service->writeDescriptor(glChar.descriptor(QBluetoothUuid(QBluetoothUuid::ClientCharacteristicConfiguration)),enable_indication);//pozwala książce wysyłać dane

            if (lastSequenceNumber == 0) {
                setWiadomosc("Pobieranie wszystkich pomiarow");
                m_service->writeCharacteristic(glChar, requestRACPMeasurements(true));
            } else {
                setWiadomosc("Pobieranie ostatnich pomiarow");
                m_service->writeCharacteristic(glChar, requestRACPMeasurements(false, lastSequenceNumber));
            }
        }

        break;
    }
    default:
    break;
    }
}

void Glukometr::serviceError(QLowEnergyService::ServiceError e)
{
    switch (e)
    {
    case QLowEnergyService::DescriptorWriteError:
        setWiadomosc("...");
        break;
    default:
        break;
    }
}

void Glukometr::updateGlukometrValue(const QLowEnergyCharacteristic &c,const QByteArray &value)//dostaje informację o np. pomiarach, książce
{

    if (c.uuid() == QBluetoothUuid(QBluetoothUuid::RecordAccessControlPoint))
    {
        ostatni=false;
        Historia *pomiar = (Historia*)m_pomiary.first();//wyświetlanie ostatniego pomiaru
        setWiadomosc("Ostatni pomiar: " + QString::number(pomiar->getCukier()) + " mg/dL");
    }

    if (c.uuid() == QBluetoothUuid(QBluetoothUuid::GlucoseMeasurementContext))
    {
        glukozaPomiarKontekst(value);
    }

    if (c.uuid()== QBluetoothUuid(QBluetoothUuid::GlucoseMeasurement))
    {
        Historia* cukier = parseGlucoseMeasurementData(value); //jeśli dostał pomiar zapisuje do zmiennej cukier



        if (cukier->getCukier() != 0)
        {
            if (m_pomiary.count() > 0)
                if (((Historia*)m_pomiary.first())->getDataPomiaru() == cukier->getDataPomiaru())// po wybraniu "na czczo" itp nie pobiera dwukrotnie pomiaru
                    return;
            m_pomiary.prepend(cukier); //dodaje do listy pomiarów     prepend dodaje elementy na górze listy nie na dole
        }


        if(!ostatni)
        {
            setWiadomosc("Ostatni pomiar: " + QString::number(cukier->getCukier()) + " mg/dL");
        }

        Q_EMIT pomiaryChanged();//zmiana listy pomiarów
    }
}

QByteArray Glukometr::requestRACPMeasurements(bool all, int last_sequence) {
    QByteArray request = QByteArray::fromHex("01");

    if (all) {
        // Request Records with All Records op code
        request.append(QByteArray::fromHex("01"));
    } else {
        // Request Records with sequence number greater than
        request.append(QByteArray::fromHex("0301"));

        // convert sequence number to bytes
        QByteArray sequence(2, 0);
        QDataStream stream(&sequence, QIODevice::WriteOnly);

        // bluetooth expects sequence number encoded in little endian
        stream.setByteOrder(QDataStream::LittleEndian);

        // add sequence number to our request packet
        stream << last_sequence;
        request.append(sequence);

        // truncate to 5 bytes because otherwise bluetooth is sad :(((((
        request.truncate(5);
    }
    return request;
}

void Glukometr::confirmedDescriptorWrite(const QLowEnergyDescriptor &d,const QByteArray &value)
{
    if (d.isValid() && d == m_notificationDesc && value == QByteArray::fromHex("0000")) //zapisały się informację w momencie kiedy funkcja się wyłączyła i sprawdzamy czy aby na pewno chcemy się rozłączyć z urządzeniem
    {
        m_control->disconnectFromDevice();
        delete m_service;
        m_service = 0;
    }
}

int Glukometr::measurements(int index) const
{
    if (index > m_measurements.size())
        return 0;
    else
        return (int)m_measurements.value(index);
}

int Glukometr::measurementsSize() const
{
    return m_measurements.size();
}

QString Glukometr::urzadzenieAdres() const
{
    return m_currentUrzadzenie.getAdres();
}

int Glukometr::numUrzadzenia() const
{
    return m_urzadzenia.size();
}
