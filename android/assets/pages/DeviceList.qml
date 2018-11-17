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
    }

    Flickable
    {
        anchors.fill: parent
        /*PullDownMenu
        {
            MenuItem
            {
                text: bleDiscovery.running ? "Zatrzymaj wyszukiwanie" : "Szukaj urządzeń"
                onClicked: {
                    if (bleDiscovery.running)
                        bleDiscovery.stopDiscovery();
                    else {
                        discoveredDevices.clear()
                        bleDiscovery.startDiscovery();
                    }
                }
            }
        }*/

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
                        onClicked: devices.remove(device_id)
                    }
                }

                onClicked: pageStack.push("qrc:/assets/pages/DeviceConnection.qml", {"deviceId": device_id, "macAddress": mac_address });

                IconLabel {
                    id: bluetoothIcon
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        leftMargin: Theme.horizontalPageMargin
                    }
                    text: "\ue1a7"
                    width: Theme.iconSizeMedium
                    height: width
                }

                Label
                {
                    id: deviceAdd
                    anchors
                    {
                       left: bluetoothIcon.right
                       top: parent.top
                       topMargin: Theme.paddingSmall
                       leftMargin: Theme.paddingSmall
                    }
                    font.pixelSize: Theme.fontSizeMedium
                    color: Theme.primaryColor
                    text: name
                }

                Label
                {
                    id: lastSyncDate
                    anchors
                    {
                        top: deviceAdd.bottom
                        left: bluetoothIcon.right
                        leftMargin: Theme.paddingSmall
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
                top: discoveryProgressBar.visible ? discoveryProgressBar.bottom : discoveredDevicesHeader.bottom
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
                IconLabel {
                    id: bluetoothIcon2
                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        leftMargin: Theme.horizontalPageMargin
                    }
                    text: "\ue1a7"
                    width: Theme.iconSizeMedium
                    height: width
                }

                Label
                {
                    id: device
                    anchors
                    {
                       left: bluetoothIcon2.right
                       verticalCenter: parent.verticalCenter
                       leftMargin: Theme.paddingMedium
                    }
                    font.pixelSize: Theme.fontSizeMedium
                    color: Theme.primaryColor
                    text: name
                }
            }
        }
    }
}
