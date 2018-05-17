import QtQuick 2.0
import Sailfish.Silica 1.0
import glukometr 1.0


Page
{
    id: screen

    BleDiscovery
    {
        id: bleDiscovery
        onNewDevice: pythonGlukometr.addDevice(name, macAddress, false)
        // Component.onCompleted: startDiscovery()
    }

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: column.height

        Column
        {
            id: column
            width: screen.width
            spacing: Theme.paddingLarge

            PageHeader { title: "Wybierz urządzenie" }

            SectionHeader
            {
                font.pixelSize: Theme.fontSizeLarge
                text: "Zapamiętane urządzenie"
                font.bold: true
            }

            Repeater
            {
                width: parent.width
                model: pythonGlukometr.rememberedDevices

                delegate: ListItem
                {
                    contentHeight: deviceAdd.height + lastSyncDate.height + Theme.paddingSmall*3

                    menu: ContextMenu
                    {
                        MenuItem
                        {
                            text: "Zmień nazwę urządzenia"
                            onClicked:
                            {
                                var dialog = pageStack.push(Qt.resolvedUrl("ChangeNameDeviceDialog.qml"))
                                dialog.accepted.connect(function()
                                {
                                    pythonGlukometr.renameDevice(id, dialog.name)
                                })
                            }
                        }

                        MenuItem
                        {
                            text: "Zapomnij urządzenie"
                            onClicked: pythonGlukometr.forgetDevice(id)
                        }
                    }

                    onClicked: pageStack.push("monitor.qml", {"deviceId": id, "macAddress": mac_address });

                    Image {
                        id: bluetoothIcon
                        source: "image://Theme/icon-m-bluetooth-device"
                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                            leftMargin: Theme.horizontalPageMargin
                        }
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
                        text: last_sync.getTime() === 0 ? "Nigdy" : last_sync.toLocaleString()
                        color: Theme.secondaryColor
                    }
                }
            }

            SectionHeader
            {
                font.pixelSize: Theme.fontSizeLarge
                text: "Wykryte urządzenia"
                font.bold: true
            }

            ProgressBar
            {
                 anchors { left: parent.left; right: parent.right }
                 visible: bleDiscovery.running
                 label: "Szukanie urządzeń"
                 indeterminate: true
            }

            Button
            {
                visible: !bleDiscovery.running
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Szukaj bro"
                onClicked: bleDiscovery.startDiscovery()
            }

            Repeater
            {
                model: pythonGlukometr.discoveredDevices

                delegate: ListItem
                {
                    onClicked:
                    {
                        pythonGlukometr.addDevice(name, mac_address, true)
                        pageStack.push("monitor.qml", {"deviceId": -1, "macAddress": mac_address});
                    }

                    Image {
                        id: bluetoothIcon2
                        source: "image://Theme/icon-m-bluetooth-device"
                        anchors {
                            left: parent.left
                            top: parent.top
                            topMargin: Theme.paddingSmall
                            leftMargin: Theme.horizontalPageMargin
                        }
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
                           leftMargin: Theme.paddingSmall
                        }
                        font.pixelSize: Theme.fontSizeMedium
                        color: Theme.primaryColor
                        text: name
                    }
                }
            }
        }
    }
}
