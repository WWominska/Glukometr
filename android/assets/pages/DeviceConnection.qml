import QtQuick 2.0
import QtQuick.Controls 2.3
import glukometr 1.0
import "../components"
import ".."

Page
{
    id: page
    property int deviceId
    property string macAddress

    function getLastSequenceNumber() {
        measurements.getLastSequenceNumber(deviceId);
    }

    Connections {
        target: measurements
        onLastSequenceNumber: {
            console.log(deviceId + " " + sequenceNumber);
            if (page.deviceId == deviceId) {
                glucometer.lastSequenceNumber = sequenceNumber
                glucometer.connectToService(macAddress)
            }
        }
    }

    Component.onCompleted: {
        if (deviceId != -1)
            getLastSequenceNumber()
        else {
            page.deviceId = devices.getDeviceId(macAddress)
            getLastSequenceNumber()
        }
    }

    Glucometer
    {
        id: glucometer
        deviceId: page.deviceId

        onError: logi.text = "Wystąpił błąd"
        onInvalidService: logi.text = "Nie pobrano danych"
        onConnecting: {
            reconnectBtn.visible = false
            logi.text = "Łączenie..."
        }
        onConnected: logi.text = "Połączono"
        onDisconnected: {
            reconnectBtn.visible = true
            logi.text = "Rozłączono"
        }
        onNotAGlucometer: logi.text = "Urządzenie nie jest glukometrem"
        onPairing: logi.text = "Parowanie..."
        onRacpStarted: logi.text = "Pobieranie pomiarów"
        onRacpFinished: {
            devices.update(page.deviceId, {"last_sync": -1})
            measurements.get()
            logi.text = "Pobrano wszystko"
            pageStack.pop(0)
        }
        onMealChanged:
        {
            var newMeal = -1;

            // convert Bluetooth's meal to our meal
            switch (meal) {
                case 1: newMeal = 1; break;   // przed posiłkiem
                case 2: newMeal = 2; break;   // po posiłku
                case 3: newMeal = 0; break;   // na czczo
                case 5: newMeal = 3; break;   // nocna
                default: newMeal = -1; break; // nie okreslono
            }

            measurements.update({
                "sequence_number": sequence_number,
                "device_id": device
            }, {"meal": newMeal}, true)
        }

        onNewMeasurement:
        {
            measurements.add({
                "value": value,
                "timestamp": timestamp,
                "device_id": device,
                "sequence_number": sequence_number,
                "meal": -1
            })
        }
    }


    Item
    {
        id: updatei
        width: parent.width
        height: Theme.paddingLarge*10
        anchors
        {
            bottom: parent.bottom
            bottomMargin: Theme.horizontalPageMargin
        }

        Label
        {
            id: logi
            text: "Oczekiwanie..."
            anchors.centerIn: updatei
            color: Theme.highlightColor
        }

        Button {
            id: reconnectBtn
            anchors {
                top: logi.bottom
                topMargin: Theme.paddingMedium
                horizontalCenter: logi.horizontalCenter
            }
            text: "Spróbuj ponownie"
            onClicked: getLastSequenceNumber()
            visible: false
        }
    }

    Item
    {
        anchors
        {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: updatei.top
        }
        Image
        {
            id: background
            width: parent.width * (2/3)
            smooth: true
            height: width
            sourceSize.width: width
            sourceSize.height: width
            anchors.centerIn: parent
            source: "qrc:/icons/icon-glucometer.svg"
            fillMode: Image.PreserveAspectFit
        }
    }
}
