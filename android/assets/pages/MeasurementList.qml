import QtQuick 2.9
import QtCharts 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.1
import QtQuick.Controls.Universal 2.1
import ".."
import "../components"

Page
{
    header: Item {
        width: parent.width
        height: pageHeader.height + (resetDates.visible ? resetDates.height + Theme.paddingSmall*2 : 0)
        PageHeader {
            id: pageHeader
            title: qsTr("Pomiary")
            leftIcon: "\ue8df"
            leftCallback: function () {
                pageStack.push("qrc:/assets/pages/Calendar.qml")
            }

            rightIcon: "\ue8b8"
            rightCallback: function () {
                pageStack.push("qrc:/assets/pages/Settings.qml")
            }
        }
        Button {
            id: resetDates
            anchors
            {
                top: pageHeader.bottom
                left: parent.left
                right: parent.right
                topMargin: Theme.paddingSmall
                bottomMargin: Theme.paddingSmall
                leftMargin: Theme.horizontalPageMargin
                rightMargin: Theme.horizontalPageMargin
            }
            width: parent.width
            z: 20
            text: qsTr("Pokaż wszystkie")
            onClicked: {
                application.datesSet = false
                measurements.get(true)
            }
            visible: application.datesSet
        }
    }
    background: OreoBackground {}
    id: results
    Connections {
        target: thresholds
        onModelChanged: measurements.get()
    }

    FloatingActionButton {
        Material.foreground: "#000"
        Material.background: "#ccff7575"
        text: "\ue145"
        onClicked: openAddMeasurementDialog()
    }

    ListView
    {
        ScrollBar.vertical: ScrollBar { }
        id: book
        header: ChartView {
            id: plaaceeek
            width: parent.width
            height: parent.height * 0.3
            theme: ChartView.ChartThemeDark
            antialiasing: true

            PieSeries {
                id: pieSeries
                PieSlice { label: "Prawidłowe"; value: 94.9 }
                PieSlice { label: "Hipoglikemia"; value: 5.1 }
                PieSlice { label: "Hiperglikemia"; value: 20 }
            }
        }

        anchors.fill: parent

        model: measurements.model
        section {
            property: "date_measured"
            delegate: Rectangle
            {
                height: tekst.paintedHeight + Theme.paddingMedium
                width: parent.width
                color: "#77000000"
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
            contentHeight: sugar.height + whenMeasurement.height + Theme.paddingSmall*3
            onClicked: pageStack.push(Qt.resolvedUrl("qrc:/assets/pages/MeasurementDetails.qml"), {
                                          "measurement_id": measurement_id,
                                          "value": value,
                                          "meal": meal,
                                          "timestamp": timestamp
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
                                                                         {"meal": meal})
                        dialog.accepted.connect(function()
                        {
                            measurements.update({
                                "measurement_id": measurement_id
                            }, {"meal": dialog.meal}, true);
                        })
                    }
                }
                MenuItem
                {
                    text: qsTr("Usuń")
                    onClicked: measurements.remove(measurement_id)
                }
            }

            Item
            {
                Rectangle {
                    width: Theme.itemSizeExtraSmall/3
                    height: Theme.itemSizeExtraSmall/3
                    anchors.centerIn: parent
                    color: thresholds.evaluateMeasurement(value, meal)
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
                text: value
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
                text: changeToString(meal)
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
                text: new Date(timestamp*1000).toLocaleString(Qt.locale(),"HH:mm")
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
