#ifndef GLUKOMETR_H
#define GLUKOMETR_H

#include <QString>
#include <QDebug>
#include <QDateTime>
#include <QByteArray>
#include <QVector>
#include <QLowEnergyController>
#include <QLowEnergyService>
#include <QLowEnergyDescriptor>
#include <QLowEnergyCharacteristic>
#include <QTimer>


QT_USE_NAMESPACE
class Glukometr: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString wiadomosc READ wiadomosc NOTIFY wiadomoscChanged)
    Q_PROPERTY(int lastSequenceNumber READ getLastSequenceNumber
               WRITE setLastSequenceNumber
               NOTIFY lastSequenceNumberChanged)

public:
    Glukometr();
    ~Glukometr();
    void setWiadomosc(QString wiadomosc);
    void glukozaPomiarKontekst(QByteArray data);
    QString wiadomosc() const;

    int getLastSequenceNumber() {
        return lastSequenceNumber;
    }

    void setLastSequenceNumber(int _lastSequenceNumber) {
        qDebug() << "last number" << _lastSequenceNumber;
        lastSequenceNumber = _lastSequenceNumber;
    }

    void parseGlucoseMeasurementData(QByteArray data);
    QDateTime convertTime(QByteArray data, int offset);

    quint16 bytesToInt(quint8 b1, quint8 b2);
    float bytesToFloat(quint8 b1, quint8 b2);
    int unsignedToSigned(int b, int size);

public slots:
    void connectToService(const QString &adres);
    void disconnectService();

    // Record Access Control Point
    QByteArray requestRACPMeasurements(bool all=false, int last_sequence=0);

private slots:
    //QLowEnergyController
    void serviceDiscovered(const QBluetoothUuid &);
    void serviceScanDone();
    void controllerError(QLowEnergyController::Error);
    void urzadzenieConnected();
    void urzadzenieDisconnected();


    //QLowEnergyService
    void serviceStateChanged(QLowEnergyService::ServiceState s);
    void updateGlukometrValue(const QLowEnergyCharacteristic &c,
                              const QByteArray &value);
    void confirmedDescriptorWrite(const QLowEnergyDescriptor &d,
                              const QByteArray &value);
    void serviceError(QLowEnergyService::ServiceError e);

signals:
    void newMeasurement(float value, QDateTime timestamp, int device, int sequence_number);
    void mealChanged(int device, int sequence_number, int meal);

    void wiadomoscChanged();
    void lastSequenceNumberChanged();

private:
    QLowEnergyDescriptor m_notificationDesc;
    QString m_info;
    bool foundGlukometrService;
    bool ostatni;
    QLowEnergyController *m_control;
    QLowEnergyService *m_service;

    int lastSequenceNumber;

    QByteArray enable_indication;
    QByteArray enable_notification;
};

#endif // GLUKOMETR_H
