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
        height: pageHeader.height + (resetDates.visible ? resetDates.height + Theme.paddingSmall*2 : 0) + (buttons.visible ? buttons.height + Theme.paddingSmall*2 : 0)
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
        Row {
            id: buttons
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
            spacing: Theme.paddingSmall
            width: parent.width
            visible: inSelectMode
            ToolButton {
                text: "\ue5c4"
                font.family: "Material Icons"
                font.pixelSize: 20
                onClicked: {
                    selected = [];
                    inSelectMode = false;
                }
            }
            ToolButton {
                text: "Usuń wszystkie"
                font.pixelSize: 20
                onClicked: {
                    measurements.remove({}, true)
                }
            }
            ToolButton {
                text: "\ue872"
                font.family: "Material Icons"
                font.pixelSize: 20
                onClicked: {
                    selected.map(
                        function (id) {
                            measurements.remove(id, false);
                        }
                    )
                    measurements.get()
                }
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
    Connections {
        target: measurements
        onModelChanged: if (measurements.model.rowCount() === 0) {
                                inSelectMode = false;
                            }
    }
    property bool inSelectMode: false
    property var selected: []
    background: OreoBackground {}
    id: results
    Connections {
        target: thresholds
        onModelChanged: measurements.get()
    }

    FloatingActionButton {
        visible: !inSelectMode
        Material.foreground: "#000"
        Material.background: "#ccff7575"
        text: "\ue145"
        onClicked: {
            inSelectMode = false;
            openAddMeasurementDialog();
        }
    }

    ListView
    {
        ScrollBar.vertical: ScrollBar { }
        id: book
        header: Rectangle {
            color: "#66262626"
            height: (results.height * 0.3) + 20
            width: parent.width
            Column {
                id: przepisNaPlacek
                spacing: Theme.paddingLarge
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: Theme.paddingLarge *2
                }
                width: parent.width / 2

                Row {
                    spacing: Theme.paddingMedium
                    Rectangle {
                        color: "#DB4F56"
                        height: 14
                        width: 14
                        radius: 7
                    }

                    Label {
                        text: "Hipoglikemia"
                    }
                }

                Row {
                    spacing: Theme.paddingMedium
                    Rectangle {
                        color: "#1DDE4D"
                        height: 14
                        width: 14
                        radius: 7
                    }

                    Label {
                        text: "Prawidłowo"
                    }
                }

                Row {
                    spacing: Theme.paddingMedium
                    Rectangle {
                        color: "#FFF757"
                        height: 14
                        width: 14
                        radius: 7
                    }

                    Label {
                        text: "Hiperglikemia"
                    }
                }
            }

            ChartView {
                id: plaaceeek
                height: parent.height
                width: (parent.width / 2) + 40
                x: (parent.x + parent.width) - (width - 20)
                y: 0
                antialiasing: true
                backgroundColor: "transparent"
                backgroundRoundness: 0
                legend.visible: false

                margins {
                    bottom: 0
                    top: 0
                    left :0
                    right: 0
                }

                PieSeries {
                    id: pieSeries
                    PieSlice { label: "Prawidłowe"; value: measurements.green; color: "#1DDE4D"; borderColor: 'transparent' }
                    PieSlice { label: "Hipoglikemia"; value: measurements.red; color: "#DB4F56"; borderColor: 'transparent'}
                    PieSlice { label: "Hiperglikemia"; value: measurements.yellow; color: "#FFF757"; borderColor: 'transparent' }
                }
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
                MenuItem {
                    text: qsTr("Zaznacz")
                    onClicked: {
                        if (!inSelectMode) {
                            selected = [];
                            inSelectMode = true;
                            listItemCheckbox.checked = true;
                        }
                        listItemCheckbox.checked = true;
                    }
                }

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

            CheckBox {
                id: listItemCheckbox
                Material.accent: "#99000000"
                anchors {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
                Connections {

                    target: results
                    onInSelectModeChanged: {
                        listItemCheckbox.checked = false
                    }
                }

                onCheckedChanged: {
                    if (checked) {
                        if (selected.indexOf(measurement_id) == -1)
                            selected.push(measurement_id)
                    } else {
                        selected = selected.filter(function (id) { return id !== measurement_id; });
                    }
                }

                visible: inSelectMode
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
                    right: inSelectMode ? listItemCheckbox.left : parent.right
                    rightMargin: Theme.horizontalPageMargin
                    top: parent.top
                    topMargin: Theme.paddingSmall
                }
                color: "#f7f5f0"
            }
        }
    }
}
