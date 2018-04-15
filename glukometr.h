#ifndef GLUKOMETR_H
#define GLUKOMETR_H

#include "urzadzenie.h"
#include "historia.h"

#include <QString>
#include <QDebug>
#include <QDateTime>
#include <QVector>
#include <QBluetoothDeviceDiscoveryAgent>
#include <QBluetoothDeviceInfo>
#include <QLowEnergyController>
#include <QLowEnergyService>
#include <QLowEnergyDescriptor>
#include <QLowEnergyCharacteristic>
#include <QTimer>


QT_USE_NAMESPACE
class Glukometr: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariant nazwa READ nazwa NOTIFY nazwaChanged)
    Q_PROPERTY(QVariant pomiary READ pomiary NOTIFY pomiaryChanged)
    Q_PROPERTY(QString wiadomosc READ wiadomosc NOTIFY wiadomoscChanged)
    Q_PROPERTY(int hr READ hR NOTIFY hrChanged)
    Q_PROPERTY(int time READ time NOTIFY timeChanged)

public:
    Glukometr();
    ~Glukometr();
    void setWiadomosc(QString wiadomosc);
    void glukozaPomiarKontekst(QByteArray data);
    QString wiadomosc() const;
    QVariant nazwa();
    QVariant pomiary();
    int hR() const;
    int time();

    Historia* parseGlucoseMeasurementData(QByteArray data);
    QDateTime convertTime(QByteArray data, int offset);

    quint16 bytesToInt(quint8 b1, quint8 b2);
    float bytesToFloat(quint8 b1, quint8 b2);
    int unsignedToSigned(int b, int size);

public slots:
    void urzadzenieSearch();
    void connectToService(const QString &adres);
    void disconnectService();

    void obtainResults();
    int measurements(int index) const;
    int measurementsSize() const;
    QString urzadzenieAdres() const;
    int numUrzadzenia() const;

private slots:
    //QBluetothDeviceDiscoveryAgent
    void addUrzadzenie(const QBluetoothDeviceInfo&);
    void scanFinished();

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

Q_SIGNALS:
    void wiadomoscChanged();
    void nazwaChanged();
    void pomiaryChanged();
    void hrChanged();
    void timeChanged();

private:
    UrzadzenieInfo m_currentUrzadzenie;
    QBluetoothDeviceDiscoveryAgent *m_urzadzenieDiscoveryAgent;
    QLowEnergyDescriptor m_notificationDesc;
    QList<QObject*> m_urzadzenia;
    QList<QObject*> m_pomiary;
    QString m_info;
    bool foundGlukometrService;
    bool ostatni;
    QVector<quint16> m_measurements;
    QDateTime m_start;
    QDateTime m_stop;
    QLowEnergyController *m_control;
    QLowEnergyService *m_service;

    QByteArray enable_indication;
    QByteArray enable_notification;
};

#endif // GLUKOMETR_H
