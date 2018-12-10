import QtQuick 2.0
import QtQuick.Controls 2.3
import glukometr 1.0
import ".."
import "../components"


Page
{
    id: screen
    property int tutorialBluetooth: application.isTutorialEnabled

    header: PageHeader {
        id: pageHeader
        title: qsTr("Wybierz urządzenie")
    }
    background: OreoBackground {}

    ListModel {
        id: discoveredDevices
    }

    BleDiscovery
    {
        id: bleDiscovery
        onNewDevice: {
            if (!devices.isKnown(macAddress)) {
                discoveredDevices.append({
                    "name": name,
                    "macAddress": macAddress
                })
            }
        }
    }

    Component.onCompleted: {
        bleDiscovery.startDiscovery()
        devices.get()
        application.bluetoothPageOpen = true

    }
    Component.onDestruction: {
        application.bluetoothPageOpen = false
        bleDiscovery.stopDiscovery()
        measurements.get()
    }

    Flickable
    {
        anchors.fill: parent

        SectionHeader
        {
            id: rememberedDevicesHeader
            font.pixelSize: Theme.fontSizeLarge
            text: qsTr("Zapamiętane urządzenie")
        }

        ListView
        {
            id: rememberedDevicesList
            anchors {
                top: rememberedDevicesHeader.bottom;
                topMargin: Theme.paddingLarge
            }
            width: parent.width
            height: contentHeight
            model: devices.model

            delegate: ListItem
            {
                id:deviceSet
                width: parent.width
                icon.name: "bluetooth"

                height: deviceAdd.height + lastSyncDate.height + Theme.paddingSmall*3
                menu: Menu
                {
                    MenuItem
                    {
                        text: qsTr("Zmień nazwę urządzenia")
                        onClicked:
                        {
                            var dialog = pageStack.push(Qt.resolvedUrl("qrc:/assets/dialogs/RenameDevice.qml"), {"name": name})
                            dialog.accepted.connect(function()
                            {
                                devices.update(
                                            device_id, {"name": dialog.name})
                            })
                        }
                    }

                    MenuItem
                    {
                        text: qsTr("Zapomnij urządzenie")
                        onClicked: {
                            devices.remove(device_id)
                        }
                    }
                }

                onClicked: pageStack.push("qrc:/assets/pages/DeviceConnection.qml", {"deviceId": device_id, "macAddress": mac_address });

                Label
                {
                    id: deviceAdd
                    x: 56
                    anchors
                    {
                       top: parent.top
                       topMargin: Theme.paddingSmall
                    }
                    font.pixelSize: Theme.fontSizeMedium
                    color: Theme.primaryColor
                    text: name
                }

                Label
                {
                    id: lastSyncDate
                    x: 56
                    anchors
                    {
                        top: deviceAdd.bottom
                    }

                    font.pixelSize: Theme.fontSizeTiny
                    text: last_sync > -1 ? new Date(last_sync*1000).toLocaleDateString() : qsTr("Nigdy")
                    color: Theme.primaryColor
                }
            }
        }

        SectionHeader
        {
            id: discoveredDevicesHeader
            anchors {
                top: rememberedDevicesList.bottom
                topMargin: Theme.paddingLarge
            }
            font.pixelSize: Theme.fontSizeLarge
            text: qsTr("Wykryte urządzenia")
        }

        Button {
            id: refreshButton
            anchors {
                top: discoveredDevicesHeader.bottom
                topMargin: Theme.paddingLarge
                left: parent.left
                leftMargin: Theme.horizontalPageMargin
                right: parent.right
                rightMargin: Theme.horizontalPageMargin
            }

            text: bleDiscovery.running ? qsTr("Zatrzymaj wyszukiwanie") : qsTr("Szukaj urządzeń")
            onClicked: {
                if (bleDiscovery.running)
                    bleDiscovery.stopDiscovery();
                else {
                    discoveredDevices.clear()
                    bleDiscovery.startDiscovery();
                }
            }
            visible: !discoveryProgressBar.visible
        }

        ProgressBar
        {
            id: discoveryProgressBar
            anchors
            {
                top: discoveredDevicesHeader.bottom
                topMargin: Theme.paddingLarge
                left: parent.left
                leftMargin: Theme.horizontalPageMargin
                right: parent.right
                rightMargin: Theme.horizontalPageMargin
            }
            visible: bleDiscovery.running
            //label: "Szukanie urządzeń"
            indeterminate: true
        }

        ListView
        {
            anchors {
                top: discoveryProgressBar.visible ? discoveryProgressBar.bottom : refreshButton.bottom
            }
            width: parent.width
            height: contentHeight
            model: discoveredDevices
            delegate: ItemDelegate
            {
                width: parent.width
                onClicked:
                {
                    devices.add({
                        "name": name,
                        "mac_address": macAddress
                    })
                    pageStack.push("qrc:/assets/pages/DeviceConnection.qml", {
                                       "deviceId": -1,
                                       "macAddress": macAddress});
                }
                icon.name: "bluetooth"
                text: name
            }
        }
    }
}
