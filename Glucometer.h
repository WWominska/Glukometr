#ifndef GLUCOMETER_H
#define GLUCOMETER_H
#include <QString>
#include <QDebug>
#include <QDateTime>
#include <QByteArray>
#include <QLowEnergyController>
#include <QLowEnergyService>
#include <QLowEnergyDescriptor>
#include <QLowEnergyCharacteristic>
#include "BleParser.h"


QT_USE_NAMESPACE
class Glucometer: public QObject
{
    Q_OBJECT
    Q_PROPERTY(int deviceId READ getDeviceId
               WRITE setDeviceId NOTIFY deviceIdChanged)
    Q_PROPERTY(int lastSequenceNumber READ getLastSequenceNumber
               WRITE setLastSequenceNumber
               NOTIFY lastSequenceNumberChanged)

public:
    Glucometer();
    ~Glucometer();
    void glukozaPomiarKontekst(QByteArray data);

    void parseGlucoseMeasurementData(QByteArray data);

    int getLastSequenceNumber();
    void setLastSequenceNumber(int lastSequenceNumber);

    int getDeviceId();
    void setDeviceId(int deviceId);

public slots:
    void connectToService(const QString &adres);

    // Record Access Control Point
    QByteArray requestRACPMeasurements(bool all=false, int last_sequence=0);

private slots:
    //QLowEnergyController
    void serviceDiscovered(const QBluetoothUuid &);
    void serviceScanDone();
    void controllerError(QLowEnergyController::Error);
    void urzadzenieConnected();

    //QLowEnergyService
    void serviceStateChanged(QLowEnergyService::ServiceState s);
    void updateGlucometerValue(const QLowEnergyCharacteristic &c,
                              const QByteArray &value);
    void confirmedDescriptorWrite(const QLowEnergyDescriptor &d,
                              const QByteArray &value);
    void serviceError(QLowEnergyService::ServiceError e);

signals:
    void newMeasurement(float value, QDateTime timestamp, int device, int sequence_number);
    void mealChanged(int device, int sequence_number, int meal);

    void lastSequenceNumberChanged();
    void deviceIdChanged();

    void error();
    void invalidService();
    void connecting();
    void connected();
    void disconnected();
    void notAGlucometer();
    void pairing();
    void racpFinished();
    void racpStarted();


private:
    QLowEnergyDescriptor m_notificationDesc;
    bool foundGlucometerService;
    bool ostatni;
    QLowEnergyController *m_control;
    QLowEnergyService *m_service;

    int m_lastSequenceNumber;
    int m_deviceId;

    QByteArray enable_indication;
    QByteArray enable_notification;
};

#endif // GLUCOMETER_H
