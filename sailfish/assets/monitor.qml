import QtQuick 2.0
import Sailfish.Silica 1.0
import glukometr 1.0

Page
{
    id: page
    property int deviceId
    property string macAddress

    Component.onCompleted: {
        if (deviceId != -1)
            pythonGlukometr.getLastSequenceNumber(deviceId)
        else pythonGlukometr.getDeviceId(macAddress)
    }

    Connections {
        target: pythonGlukometr
        onGotDeviceId: {
            if (page.macAddress == macAddress) {
                page.deviceId = deviceId
                pythonGlukometr.getLastSequenceNumber(deviceId)
            }
        }

        onGotLastSequenceNumber: {
            if (page.deviceId == deviceId)
                glucometer.lastSequenceNumber = lastSequenceNumber;

            // ready to connect
            glucometer.connectToService(macAddress)
        }
    }

    Glucometer {
        id: glucometer
        deviceId: page.deviceId

        onError: logi.text = "Wystąpił błąd"
        onInvalidService: logi.text = "Nie pobrano danych"
        onConnecting: logi.text = "Łączenie..."
        onConnected: logi.text = "Połączono"
        onDisconnected: logi.text = "Rozłączono"
        onNotAGlucometer: logi.text = "Urządzenie nie jest glukometrem"
        onPairing: logi.text = "Parowanie..."
        onRacpStarted: logi.text = "Pobieranie pomiarów"
        onRacpFinished: logi.text = "Pobrano wszystko"

        onNewMeasurement: {
            pythonGlukometr.addMeasurement(value, timestamp, device,
                                           sequence_number, -1)
        }
    }


    Rectangle
    {
        id: updatei
        width: parent.width
        height: 80
        anchors.bottom: stop.top

        Label
        {
            id: logi
            text: "Oczekiwanie..."
            anchors.centerIn: updatei
            color: Theme.highlightColor
        }
    }

    Image {
        id: background
        width: 300
        height: width
        anchors.centerIn: parent
        source: "glucometr.png"
        fillMode: Image.PreserveAspectFit
    }

    Button
    {
        id:stop
        width: parent.width
        height: 0.1*parent.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        text: "Stop"
        color: "#209B9B"
        highlightBackgroundColor: "#2DC4C4"
        onClicked: pageStack.pop()
    }
}
