import QtQuick 2.0
import Sailfish.Silica 1.0
import glukometr 1.0


Page
{
    id: screen
    property int tutorialBluetooth: application.isTutorialEnabled

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

    SilicaFlickable
    {
        anchors.fill: parent
        PullDownMenu
        {
            MenuItem
            {
                text: bleDiscovery.running ? qsTr("DEVICE_SEARCH_STOP_LABEL") : qsTr("DEVICE_SEARCH_START_LABEL")
                onClicked: {
                    if (bleDiscovery.running)
                        bleDiscovery.stopDiscovery();
                    else {
                        discoveredDevices.clear()
                        bleDiscovery.startDiscovery();
                    }
                }
            }
        }

        PageHeader
        {
            id: pageHeader
            title: qsTr("DEVICE_LIST_TITLE")
        }

        SectionHeader
        {
            id: rememberedDevicesHeader
            anchors {
                top: pageHeader.bottom;
                topMargin: Theme.paddingLarge
            }
            font.pixelSize: Theme.fontSizeLarge
            text: qsTr("DEVICE_KNOWN_LABEL")
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
                RemorseItem { id: remorse }
                contentHeight: deviceAdd.height + lastSyncDate.height + Theme.paddingSmall*3
                menu: ContextMenu
                {
                    MenuItem
                    {
                        text: qsTr("DEVICE_RENAME_LABEL")
                        onClicked:
                        {
                            var dialog = pageStack.push(Qt.resolvedUrl("qrc:/assets/dialogs/RenameDevice.qml"), {"name": name})
                            dialog.accepted.connect(function()
                            {
                                devices.update(device_id, {"name": dialog.name})
                            })
                        }
                    }

                    MenuItem
                    {
                        text: qsTr("DEVICE_FORGET_LABEL")
                        onClicked: remorse.execute(deviceSet, qsTr("DEVICE_FORGET_REMORSE"), function() {
                            devices.remove(device_id)
                        })
                    }
                }

                onClicked: pageStack.push("qrc:/assets/pages/DeviceConnection.qml", {"deviceId": device_id, "macAddress": mac_address });

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
                    text: last_sync > 0 ? new Date(last_sync*1000).toLocaleDateString() : qsTr("DEVICE_SYNC_NEVER")
                    color: Theme.secondaryColor
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
            text: qsTr("DEVICE_DISCOVERED_LABEL")
        }

        ProgressBar
        {
            id: discoveryProgressBar
            anchors
            {
                top: discoveredDevicesHeader.bottom
                topMargin: Theme.paddingLarge
                left: parent.left
                right: parent.right
            }
            visible: bleDiscovery.running
            label: qsTr("DEVICE_PROGRESS_LABEL")
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
            delegate: ListItem
            {
                onClicked:
                {
                    devices.add({
                        "name": name,
                        "mac_address": macAddress
                    })
                    pageStack.push("qrc:/assets/pages/DeviceConnection.qml", {
                                       "deviceId": -1,
                                       "last_sync": -1,
                                       "macAddress": macAddress});
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
//    InteractionHintLabel
//    {
//        id:bluetooth
//        text: "Tutaj możesz wybrać glukometr, do którego chcesz się połączyć, klikając na niego"
//        color: Theme.secondaryColor
//        anchors.bottom: parent.bottom
//        opacity: tutorialBluetooth ? 1.0 : 0.0
//        Behavior on opacity { FadeAnimation {} }
//        invert: false
//    }

////    TouchInteractionHint
////    {
////        id: hint
////        loops: Animation.Infinite
////        interactionMode: TouchInteraction.Pull
////        direction: TouchInteraction.Down
////    }

//    Connections
//    {
//        target: application
//        onIsTutorialEnabledChanged: hint.start()
//    }
}
