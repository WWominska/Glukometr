import QtQuick 2.0
import Sailfish.Silica 1.0
import glukometr 1.0

Page
{
    id: page
    property int deviceId
    property string macAddress

    function getLastSequenceNumber() {
        pythonGlukometr.measurements.getLastSequenceNumber(deviceId, function (lastSequenceNumber) {
            glucometer.lastSequenceNumber = lastSequenceNumber;
            glucometer.connectToService(macAddress)
        })
    }

    Component.onCompleted: {
        if (deviceId != -1)
            getLastSequenceNumber()
        else pythonGlukometr.devices.getDeviceId(macAddress, function (deviceId) {
            page.deviceId = deviceId
            getLastSequenceNumber()
        })
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
        onRacpFinished: {
            pythonGlukometr.devices.update(page.deviceId, {"last_sync": -1})
            pythonGlukometr.measurements.get()
            logi.text = "Pobrano wszystko"
        }
        onMealChanged: {
            var newMeal = -1;

            // convert Bluetooth's meal to our meal
            switch (meal) {
                case 1: newMeal = 1; break;   // przed posiłkiem
                case 2: newMeal = 2; break;   // po posiłku
                case 3: newMeal = 0; break;   // na czczo
                case 5: newMeal = 3; break;   // nocna
                default: newMeal = -1; break; // nie okreslono
            }

            pythonGlukometr.measurements.update({
                "sequence_number": sequence_number,
                "device_id": device
            }, {"meal": newMeal}, true)
        }

        onNewMeasurement: {
            pythonGlukometr.measurements.add({
                "value": value,
                "timestamp": timestamp,
                "device_id": device,
                "sequence_number": sequence_number,
                "meal": -1
            })
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
