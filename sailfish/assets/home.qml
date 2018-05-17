import QtQuick 2.0
import Sailfish.Silica 1.0
import glukometr 1.0


Page {
    id: screen

    BleDiscovery {
        id: bleDiscovery
        onNewDevice: pythonGlukometr.addDevice(name, macAddress, false)
        Component.onCompleted: startDiscovery()
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column
            width: screen.width
            spacing: Theme.paddingLarge

            PageHeader { title: "Wybierz urządzenie" }

            SectionHeader { text: "Zapamiętane urządzenia" }
            Repeater {
                width: parent.width
                model: pythonGlukometr.rememberedDevices

                delegate: Rectangle {
                    id: box
                    height:100
                    width: parent.width
                    color: "#2dc4c4"
                    radius: 15

                    MouseArea {
                        anchors.fill: parent
                        onPressed: { box.color= "#209b9b"; box.height=110}
                        onClicked: pageStack.push("monitor.qml", {
                                       "deviceId": id,
                                       "macAddress": mac_address
                                    });
                    }

                    Label {
                        font.pixelSize: Theme.fontSizeMedium
                        text: name
                        anchors.top: parent.top
                        anchors.topMargin: 5
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "#000000"
                    }

                    Label {
                        font.pixelSize: Theme.fontSizeTiny
                        text: mac_address
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 5
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "#000000"
                    }
                }
            }

            SectionHeader { text: "Wykryte urządzenia" }
            ProgressBar {
                 visible: bleDiscovery.running
                 label: "Szukanie urządzeń"
                 indeterminate: true
             }

            Button {
                visible: !bleDiscovery.running
                text: "Szukaj bro"
                onClicked: bleDiscovery.startDiscovery()
            }

            Repeater {
                model: pythonGlukometr.discoveredDevices

                delegate: Rectangle {
                    id: dBox
                    height:100
                    width: parent.width
                    color: "#2dc4c4"
                    border.color: "#000000"
                    border.width: 5
                    radius: 15

                    MouseArea {
                        anchors.fill: parent
                        onPressed: { dBox.color= "#209b9b"; dBox.height=110}
                        onClicked: {
                            pythonGlukometr.addDevice(name, mac_address, true)
                            pageStack.push("monitor.qml", {
                                "deviceId": -1,
                                "macAddress": mac_address
                            });
                        }
                    }

                    Label {
                        font.pixelSize: Theme.fontSizeMedium
                        text: name
                        anchors.top: parent.top
                        anchors.topMargin: 5
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "#000000"
                    }

                    Label {
                        font.pixelSize: Theme.fontSizeTiny
                        text: mac_address
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 5
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: "#000000"
                    }
                }
            }
        }
    }
}
