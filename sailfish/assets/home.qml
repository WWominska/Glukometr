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
                text: "Zapamiętaj urządzenie"
                font.bold: true
            }

            Repeater
            {
                width: parent.width
                model: pythonGlukometr.rememberedDevices

                delegate: ListItem
                {
                    contentHeight: deviceAdd.height + whenMeasurmentAdd.height + Theme.paddingSmall*3

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

                    Label
                    {
                        id:deviceAdd
                        anchors
                        {
                           left: parent.left
                           top: parent.top
                           topMargin: Theme.paddingSmall
                           leftMargin: Theme.horizontalPageMargin
                        }
                        font.pixelSize: Theme.fontSizeMedium
                        color: "#ffffff"
                        text: name
                    }

                   Label
                   {
                       id:whenMeasurmentAdd
                       anchors
                       {
                           top: deviceAdd.bottom
                           topMargin: Theme.paddingSmall
                           left: parent.left
                           leftMargin: Theme.horizontalPageMargin
                       }

                        font.pixelSize: Theme.fontSizeTiny
                        text: mac_address
                        color: Theme.secondaryHighlightColor
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
                contentHeight: device.height + whenMeasurment.height + Theme.paddingSmall*3
                onClicked:
                {
                    pythonGlukometr.addDevice(name, mac_address, true)
                    pageStack.push("monitor.qml", {"deviceId": -1, "macAddress": mac_address});
                }

                Label
                {
                    id:device
                    anchors
                    {
                       left: parent.left
                       top: parent.top
                       topMargin: Theme.paddingSmall
                       leftMargin: Theme.horizontalPageMargin
                    }
                    font.pixelSize: Theme.fontSizeMedium
                    color: "#ffffff"
                    text: name
                }

               Label
               {
                   id:whenMeasurment
                   anchors
                   {
                       top: device.bottom
                       topMargin: Theme.paddingSmall
                       left: parent.left
                       leftMargin: Theme.horizontalPageMargin
                   }

                    font.pixelSize: Theme.fontSizeTiny
                    text: mac_address
                    color: Theme.secondaryHighlightColor
                }
                }
            }
        }
    }
}
