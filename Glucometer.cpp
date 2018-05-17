#include "Glucometer.h"
#include <QDataStream>

#include <QtEndian>
#include <QtMath>


void Glucometer::parseGlucoseMeasurementData(QByteArray data)
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

    quint16 sequenceNumber = BleParser::bytesToInt(data[offset], data[offset+1]); //przechowuje liczbe przez to że jest qu tzn że nie ma żadnego znaku a 16 to długość
    qDebug() << sequenceNumber;

    offset += 2;

    // odczytaj datę i przejdź o 7 bajtów dalej (tyle zajmuje)
    QDateTime dataPomiaru = BleParser::convertTime(data, offset);
    offset += 7;

    // offset czasowy
    quint16 timeOffset = 0;

    // jeśli dano offset czasowy, odczytaj
    if (timeOffsetPresent)
    {
        timeOffset = BleParser::bytesToInt(data[offset], data[offset+1]); // offset zajmuje 2 bajty
        // przejdź o 2 bajty dalej
        offset += 2;
    }

    float glucoseConcentration = 0;
    // jeśli jest typ miejsce pomiaru
    if (typeAndLocationPresent)
    {
        glucoseConcentration = BleParser::bytesToFloat(data[offset], data[offset+1]);
    }

    emit newMeasurement(glucoseConcentration, dataPomiaru, m_deviceId,
                        sequenceNumber);
}

void Glucometer::glukozaPomiarKontekst(QByteArray data)
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
    quint16 sequenceNumber = BleParser::bytesToInt(data[offset], data[offset+1]); //przechowuje liczbe przez to że jest qu tzn że nie ma żadnego znaku a 16 to długość
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
        carbohydrate_units = BleParser::bytesToFloat(data[offset+1], data[offset+2]);
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
        exerciseDuration = BleParser::bytesToInt(data[offset], data[offset+1]); // dlugosc cwiczen (?) zajmuje 2 bajty
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
        medicationQuantity = BleParser::bytesToFloat(data[offset+1], data[offset+2]);
        offset += 3;
    }

    if (hbA1cPresent)
        HbA1c = BleParser::bytesToFloat(data[offset], data[offset+1]);

    emit mealChanged(m_deviceId, sequenceNumber, meal);
}

//QBluetoothDeviceInfo - Zbiera i dostarcza informację na temat urządzenia Bluetooth (nazwa, adres, klasa)
//QBluetoothDeviceDiscoveryAgent - odszukuje pobliskie urządzenia Bluetooth
Glucometer::Glucometer():
    foundGlucometerService(false), m_control(0), m_service(0)
{
    enable_indication = QByteArray::fromHex("0200");
    enable_notification = QByteArray::fromHex("0100");//stałe zgapione ze specyfikacji

    // assume there is nothing in DB until said otherwise
    m_lastSequenceNumber = 0;
    m_deviceId = 1; // default Device ID
}

Glucometer::~Glucometer()
{
    // disconnect completely
    if (m_control) {
        foundGlucometerService = false;

        //disable notifications before disconnecting
        if (m_notificationDesc.isValid() && m_service
                && m_notificationDesc.value() == enable_notification) {
            m_service->writeDescriptor(m_notificationDesc, QByteArray::fromHex("0000"));
        }

        // disconnect
        m_control->disconnectFromDevice();

        // remove from memory
        if (m_service){
            delete m_service;
            m_service = 0;
        }
    }
}

//QBluetoothUuid - generuje adres Uuid dla każdej usługi Bluetooth
//QLowEnergyController - daje dostęp do urządzeń w sieci Bluetooth i jest punktem wejścia do tworzenia sieci Buetooth

void Glucometer::connectToService(const QString &adres) //łączy się z urządzeniem i przyjmuje jako parametr jego adres
{
    if (m_control)
    {
        m_control->disconnectFromDevice();// jeśli jest połączony to ma się z nim rozłączyć
        delete m_control;
        m_control = 0;
    }

    m_control = new QLowEnergyController(QBluetoothAddress(adres), this);

    connect(m_control, SIGNAL(serviceDiscovered(QBluetoothUuid)),
            this, SLOT(serviceDiscovered(QBluetoothUuid)));//odpali się gdy zostanie znaleziona usługa
    connect(m_control, SIGNAL(discoveryFinished()),
            this, SLOT(serviceScanDone()));//skończyło się skanowanie tych usług
    connect(m_control, SIGNAL(error(QLowEnergyController::Error)),
            this, SLOT(controllerError(QLowEnergyController::Error))); //włącza się jak wystąpi jakiś błąd
    connect(m_control, SIGNAL(connected()),
            this, SLOT(urzadzenieConnected()));//połączyło się z urządzeniem
    connect(m_control, SIGNAL(disconnected()),
            this, SIGNAL(disconnected()));//rozłączyło się z urządzeniem

    emit connecting();
    m_control->connectToDevice();//łączy się z urządzenim
}

void Glucometer::urzadzenieConnected()
{
    m_control->discoverServices(); //szuka usług
    emit connected();
}

void Glucometer::serviceDiscovered(const QBluetoothUuid &gatt)
{
    qDebug() << gatt;
    if (gatt == QBluetoothUuid(QBluetoothUuid::Glucose))
    {
        foundGlucometerService = true; //funkcja sprawdzająca czy urządzenie jest Glucometerem
    }
}

//QLowEnergyCharacteristic - podaje informację o charakterystyce (nt nazwy, Uuid, wartość własności identyfikatory)
//QLowEnergyDescriptor - dostarcza informację o charakterystycę
void Glucometer::serviceScanDone() //konczy szukać usług
{
    delete m_service; //usunwa usługę z pamięci (była połączona)
    m_service = 0; //zeruje wskaźnik żeby nie pokazywał na miejsce w pamięcii
    if (foundGlucometerService) //znajduje Glucometer
    {
        emit pairing();
        m_service = m_control->createServiceObject(//łącze się do usługi, tworze wskaźnik na obiekt usługi
                    QBluetoothUuid(QBluetoothUuid::Glucose), this);
    }

    if (!m_service) //kiedy nie znajdzie Glucometeru
    {
        emit notAGlucometer();
        return;
    }

    connect(m_service, SIGNAL(stateChanged(QLowEnergyService::ServiceState)),
            this, SLOT(serviceStateChanged(QLowEnergyService::ServiceState)));//włączy się jak znajdzie informację o usłudze
    connect(m_service, SIGNAL(characteristicChanged(QLowEnergyCharacteristic,QByteArray)),
            this, SLOT(updateGlucometerValue(QLowEnergyCharacteristic,QByteArray)));//włączy się jak dostanie pomiar do tablicy bitów
    connect(m_service, SIGNAL(error(QLowEnergyService::ServiceError)),
            this, SLOT(serviceError(QLowEnergyService::ServiceError)));
    connect(m_service, SIGNAL(descriptorWritten(QLowEnergyDescriptor,QByteArray)), //sygnał został zapisany do skryptu (chce wiedzieć czy on wie że powinien coś wysłać)
            this, SLOT(confirmedDescriptorWrite(QLowEnergyDescriptor,QByteArray)));

    m_service->discoverDetails();//każe mu znaleźć info o usłudze
}

void Glucometer::controllerError(QLowEnergyController::Error error)
{
    emit this->error();
    qWarning() << "Controller Error:" << error;
}

void Glucometer::serviceStateChanged(QLowEnergyService::ServiceState s)
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
            emit invalidService();
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
            emit invalidService();
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
            emit invalidService();
            break;
        }

        else
        {
            // zasubskrybuj
            m_service->writeDescriptor(glChar.descriptor(QBluetoothUuid(QBluetoothUuid::ClientCharacteristicConfiguration)),enable_indication);//pozwala książce wysyłać dane

            if (m_lastSequenceNumber == 0) {
                m_service->writeCharacteristic(glChar, requestRACPMeasurements(true));
            } else {
                m_service->writeCharacteristic(glChar, requestRACPMeasurements(false, m_lastSequenceNumber));
            }
            emit racpStarted();
        }

        break;
    }
    default:
    break;
    }
}

void Glucometer::serviceError(QLowEnergyService::ServiceError e)
{
    switch (e)
    {
    case QLowEnergyService::DescriptorWriteError:
        emit error();
        break;
    default:
        break;
    }
}

void Glucometer::updateGlucometerValue(const QLowEnergyCharacteristic &c,const QByteArray &value)//dostaje informację o np. pomiarach, książce
{

    if (c.uuid() == QBluetoothUuid(QBluetoothUuid::RecordAccessControlPoint))
    {
        ostatni=false;
        emit racpFinished();
    }
    if (c.uuid() == QBluetoothUuid(QBluetoothUuid::GlucoseMeasurementContext))
    {
        glukozaPomiarKontekst(value);
    }

    if (c.uuid() == QBluetoothUuid(QBluetoothUuid::GlucoseMeasurement))
    {
        parseGlucoseMeasurementData(value); //jeśli dostał pomiar zapisuje do zmiennej cukier
    }
}

QByteArray Glucometer::requestRACPMeasurements(bool all, int last_sequence) {
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

void Glucometer::confirmedDescriptorWrite(const QLowEnergyDescriptor &d,const QByteArray &value)
{
    if (d.isValid() && d == m_notificationDesc && value == QByteArray::fromHex("0000")) //zapisały się informację w momencie kiedy funkcja się wyłączyła i sprawdzamy czy aby na pewno chcemy się rozłączyć z urządzeniem
    {
        m_control->disconnectFromDevice();
        delete m_service;
        m_service = 0;
    }
}

int Glucometer::getLastSequenceNumber() {
    return m_lastSequenceNumber;
}

void Glucometer::setLastSequenceNumber(int lastSequenceNumber) {
    m_lastSequenceNumber = lastSequenceNumber;
    emit lastSequenceNumberChanged();
}

int Glucometer::getDeviceId() {
    return m_deviceId;
}

void Glucometer::setDeviceId(int deviceId) {
    m_deviceId = deviceId;
    emit deviceIdChanged();
}
