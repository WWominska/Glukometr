import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.1
import QtQuick.Controls.Universal 2.1
import ".."
import "../components"

Page
{
    header: PageHeader {
        id: pageHeader
        title: qsTr("Pomiary")
    }
    background: OreoBackground {}
    id: results
    Connections {
        target: thresholds
        onModelChanged: measurements.get()
    }

    FloatingActionButton {
        Material.foreground: "#000"
        Material.background: "#99f7f5f0"
        text: "\ue145"
        onClicked: openAddMeasurementDialog()
    }

    /*Button {
        anchors {
            left: parent.left
            bottom: hlep.top
        }
        z: 20
        text: "bukła"
        onClicked: {
            measurements.get(true)
        }
    }

    Button {
        id: hlep
        anchors {
            left: parent.left
            bottom: parent.bottom
        }
        z: 20
        text: "hlep"
        onClicked: {
            var date = new Date();
            date.setDate(date.getDate() - 1);
            var date1 = new Date();
            date1.setDate(date.getDate() - 7);
            measurements.get({
                "date_measured": [date, "<=", date1, ">="]
            })
        }
    }*/

    FloatingActionButton {
        anchors.left: parent.left
        anchors.right: unset
        Material.foreground: "#000"
        Material.background: "#99f7f5f0"
        text: "w"
        onClicked: pageStack.push("qrc:/assets/pages/Calendar.qml")
    }

    ListView
    {
        ScrollBar.vertical: ScrollBar { }
        id: book
        anchors.fill: parent

        model: measurements.model
        section {
            property: "date_measured"
            delegate: Rectangle
            {
                height: tekst.paintedHeight + Theme.paddingMedium
                width: parent.width
                color: "#66000000"
                Label
                {
                    id: tekst
                    text: section
                    anchors
                    {
                        left: parent.left
                        leftMargin: Theme.paddingLarge
                        verticalCenter: parent.verticalCenter
                    }
                }
            }
        }

        delegate: ListItem
        {
            enabled: !isTutorialEnabled
            id: measurement
            width: parent.width
            //RemorseItem { id: remorse }
            contentHeight: sugar.height + whenMeasurement.height + Theme.paddingSmall*3
            onClicked: pageStack.push(Qt.resolvedUrl("qrc:/assets/pages/MeasurementDetails.qml"), {
                                          "measurement_id": model.measurement_id,
                                          "value": model.value,
                                          "meal": model.meal,
                                          "timestamp": model.timestamp
                                      })
            menu: Menu
            {
                id: contextMenu
                MenuItem
                {
                    text: qsTr("Zmień pore posiłku")
                    onClicked:
                    {
                        var dialog = pageStack.push(Qt.resolvedUrl("qrc:/assets/dialogs/ChangeMeal.qml"),
                                                                         {"meal": model.meal})
                        dialog.accepted.connect(function()
                        {
                            measurements.update({
                                "measurement_id": model.measurement_id
                            }, {"meal": dialog.meal}, true);
                        })
                    }
                }
                MenuItem
                {
                    text: qsTr("Usuń")
                    onClicked: remorse.execute(measurement, "Usunięcie pomiaru", function() {
                        measurements.remove(model.measurement_id)
                    })
                }
            }

            Item
            {
                Rectangle {
                    width: Theme.itemSizeExtraSmall/3
                    height: Theme.itemSizeExtraSmall/3
                    anchors.centerIn: parent
                    color: thresholds.evaluateMeasurement(model.value, model.meal)

                    radius: width
                }

                x: 0
                id: dot
                width: Theme.itemSizeExtraSmall
                height: Theme.itemSizeExtraSmall
                anchors.verticalCenter: sugar.verticalCenter
            }

            Label
            {
                id: sugar
                font.pixelSize: Theme.fontSizeSmall
                text: model.value
                anchors
                {
                    left: dot.right
                    top: parent.top
                    topMargin: Theme.paddingSmall
                }
                color: "#f7f5f0"
            }

            Label
            {
                function changeToString(meal)
                {
                    switch(meal)
                    {
                        case 0: return qsTr("Na czczo")
                        case 1: return qsTr("Przed posiłkiem")
                        case 2: return qsTr("Po posiłku")
                        case 3: return qsTr("Nocna")
                        default: return qsTr("Nie określono")
                    }
                }
                id: whenMeasurement
                font.pixelSize: Theme.fontSizeSmall
                text: changeToString(model.meal)
                anchors
                {
                    top: sugar.bottom
                    topMargin: Theme.paddingSmall
                    left: parent.left
                    leftMargin: Theme.horizontalPageMargin
                }
                color: "#e3decb"
            }

            Label
            {
                id: dateLabel
                font.pixelSize: Theme.fontSizeSmall
                horizontalAlignment: Text.AlignRight
                text: new Date(model.timestamp*1000).toLocaleString(Qt.locale(),"HH:mm")
                anchors
                {
                    left: whenMeasurement.right
                    right: parent.right
                    rightMargin: Theme.horizontalPageMargin
                    top: parent.top
                    topMargin: Theme.paddingSmall
                }
                color: "#f7f5f0"
            }
        }
    }
}
