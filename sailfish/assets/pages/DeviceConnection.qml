import QtQuick 2.0
import Sailfish.Silica 1.0
import glukometr 1.0

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
    Component.onDestruction: measurements.get()

    Glucometer
    {
        id: glucometer
        deviceId: page.deviceId

        onError: logi.text = qsTr("DEVICE_ERROR")
        onInvalidService: logi.text = qsTr("DEVICE_INVALID_SERVICE")
        onConnecting: {
            reconnectBtn.visible = false
            logi.text = qsTr("DEVICE_CONNECTING")
        }
        onConnected: logi.text = qsTr("DEVICE_CONNECTED")
        onDisconnected: {
            reconnectBtn.visible = true
            logi.text = qsTr("DEVICE_DISCONNECTED")
        }
        onNotAGlucometer: logi.text = qsTr("DEVICE_NOT_A_GLUCOMETER")
        onPairing: logi.text = qsTr("DEVICE_PAIRING")
        onRacpStarted: logi.text = qsTr("DEVICE_RACP_STARTED")
        onRacpFinished: {
            devices.update(page.deviceId, {"last_sync": -1})
            logi.text = qsTr("DEVICE_RACP_FINISHED")
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
            }, {"meal": newMeal}, false)
        }

        onNewMeasurement:
        {
            measurements.add({
                "value": value,
                "timestamp": Date.parse(timestamp)/1000,
                "device_id": device,
                "sequence_number": sequence_number,
                "meal": -1
            }, false)
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
            text: qsTr("DEVICE_WAITING")
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
            text: qsTr("DEVICE_TRY_AGAIN")
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
            source: "qrc:/icons/icon-glucometer" + (application.lightTheme ? "-light" : "") + ".svg"
            fillMode: Image.PreserveAspectFit
        }
    }
}
