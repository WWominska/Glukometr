import QtQuick 2.0
import Sailfish.Silica 1.0

Page
{
    id: results
    property bool inSelectMode: false
    property var selected: []
    property var colors: [
        "#DB4F56", "#FFF757", "#1DDE4D"
    ]
    Connections {
        target: thresholds
        onModelChanged: measurements.get()
    }
    Connections {
        target: measurements
        onModelChanged: {
            if (measurements.model.rowCount() === 0)
                inSelectMode = false;
        }
    }

    SilicaListView
    {
        opacity: hint.running ? disabledOpacity : 1.0
        Behavior on opacity { FadeAnimation {} }
        section {
            property: "date_measured"
            delegate: Rectangle
            {
                height: tekst.paintedHeight + Theme.paddingMedium
                width: parent.width
                color: application.lightTheme ? "#77ffffff" : "#77000000"
                Label
                {
                    id: tekst
                    text: section
                    color: Theme.primaryColor
                    anchors
                    {
                        left: parent.left
                        leftMargin: Theme.paddingLarge
                        verticalCenter: parent.verticalCenter
                    }
                }
            }
        }

        header: Item {
            width: parent.width
            height: pageHeader.height + (application.datesSet ? filtersHeader.height : 0) + (chartContainer.visible ? chartContainer.height : 0)
            PageHeader {
                id: pageHeader
                title: qsTr("MEASUREMENTS_TITLE")
            }
            Item {
                anchors.top: pageHeader.bottom
                id: filtersHeader
                width: parent.width
                height: Theme.itemSizeLarge
                visible: application.datesSet
                Label {
                    x: Theme.horizontalPageMargin
                    anchors.verticalCenter: parent.verticalCenter
                    textFormat: Text.RichText
                    text: qsTr("BETWEEN_LABEL") + " <span style='color: " + Theme.secondaryColor + "'>" + application.beginDate.toLocaleDateString(Qt.locale(), "dd-MM-yyyy") + "</span> - <span style='color: " + Theme.secondaryColor + "'>" + application.endDate.toLocaleDateString(Qt.locale(), "dd-MM-yyyy") + "</span>"
                }
                IconButton {
                    anchors.right: parent.right
                    anchors.rightMargin: Theme.horizontalPageMargin
                    anchors.verticalCenter: parent.verticalCenter
                    icon.source: "image://Theme/icon-m-dismiss"
                    onClicked: {
                        application.datesSet = false
                        measurements.get(true)
                    }
                }
            }
            Item {
                visible: measurements.model.rowCount()
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }
                id: chartContainer
                width: parent.width
                height: chart.height + 2 * Theme.paddingMedium
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
                            color: colors[0]
                            height: 14
                            width: 14
                            radius: 7
                            anchors.verticalCenter: parent.verticalCenter

                        }

                        Label {
                            text: qsTr("CHART_HYPOGLYCEMIA_LABEL")
                        }
                    }

                    Row {
                        spacing: Theme.paddingMedium
                        Rectangle {
                            color: colors[2]
                            height: 14
                            width: 14
                            radius: 7
                            anchors.verticalCenter: parent.verticalCenter

                        }

                        Label {
                            text: qsTr("CHART_CORRECT_LABEL")
                        }
                    }

                    Row {
                        spacing: Theme.paddingMedium
                        Rectangle {
                            color: colors[1]
                            height: 14
                            width: 14
                            radius: 7
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Label {
                            text: qsTr("CHART_HYPERGLYCEMIA_LABEL")
                        }
                    }
                }

                Item {
                    id: chart
                    y: Theme.paddingMedium
                    x: parent.width / 2
                    height: 300
                    width: parent.width / 2

                    Column {
                        width: Theme.itemSizeHuge * 0.7
                        anchors.centerIn: parent
                        Text {
                            id: topLabel
                            width: parent.width
                            text: "" + measurements.model.rowCount()
                            verticalAlignment: Text.AlignBottom
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: Theme.fontSizeLarge
                            color: Theme.primaryColor
                            fontSizeMode: Text.Fit
                        }
                        Rectangle {
                            id: ruler
                            width: parent.width
                            height: Math.round(2*Theme.pixelRatio)
                            color: Theme.rgba(Theme.secondaryColor, 0.4)
                            x: 0
                        }
                        Text {
                            id: bottomLabel
                            text: qsTr(
                                      "MEASUREMENT_COUNT_LABEL", "",
                                      measurements.model.rowCount())
                            width: parent.width
                            color: Theme.rgba(Theme.secondaryColor, 0.6)
                            font.pixelSize: Theme.fontSizeMedium
                            horizontalAlignment: topLabel.horizontalAlignment
                            height: topLabel.height // makes vertically centering the ruler within the surrounding circle easier
                            fontSizeMode: Text.Fit
                        }
                    }

                    Repeater {
                        id: repeater
                        model: ListModel {
                            property int total: 100
                            ListElement {
                                position: 0.0
                                bytes: 0.0
                            }
                            ListElement {
                                position: 0.0
                                bytes: 0.0
                            }
                            ListElement {
                                position: 0.0
                                bytes: 0.0
                            }
                        }
                        ProgressCircleBase {
                            backgroundColor: "transparent"
                            progressColor: colors[model.index % colors.length]
                            rotation: 360*model.position/repeater.model.total
                            value: bytes/repeater.model.total
                            anchors.centerIn: parent

                            height: width
                            width: implicitWidth
                            implicitWidth: Theme.itemSizeHuge
                            borderWidth: Math.round(Theme.paddingLarge/3)
                        }
                    }
                }
                Connections {
                    target: measurements
                    onRedChanged: {
                        repeater.model.set(0, {
                                          "bytes": measurements.red,
                                          "position" : 0
                                        })
                    }
                    onYellowChanged: {
                        repeater.model.set(1, {
                                          "bytes": measurements.yellow,
                                          "position" : measurements.red
                                        })
                    }
                    onGreenChanged: {
                        repeater.model.set(2, {
                                          "bytes": measurements.green,
                                          "position" : measurements.yellow + measurements.red
                                        })
                    }
                }
            }
        }
        PullDownMenu
        {
            id: pullDownMenu
            MenuItem
            {
                text: qsTr("SETTINGS_TITLE")
                onClicked: if (!isTutorialEnabled) pageStack.push("qrc:/assets/pages/Settings.qml")
                visible: !inSelectMode
            }

            MenuItem
            {
                text: qsTr("SETTINGS_BLUETOOTH")
                visible: !inSelectMode
                onClicked: if (!isTutorialEnabled) pageStack.push("qrc:/assets/pages/DeviceList.qml")
            }

            MenuItem {
                text: qsTr("MEASUREMENTS_CALENDAR_LABEL")
                visible: !inSelectMode
                onClicked: if (!isTutorialEnabled) pageStack.push("qrc:/assets/pages/Calendar.qml")
            }
            MenuItem {
                text: qsTr("MEASUREMENTS_SELECT")
                visible: !inSelectMode
                onClicked: {
                    selected = [];
                    inSelectMode = true;
                }
            }

            MenuItem
            {
                text: qsTr("MEASUREMENTS_ADD")
                visible: !inSelectMode
                onClicked: openAddMeasurementDialog()
            }

            MenuItem {
                visible: inSelectMode
                text: qsTr("REMOVE_ALL_LABEL")
                onClicked: measurements.remove({}, true)
            }

            MenuItem {
                visible: inSelectMode
                text: qsTr("REMOVE_SELECTED_LABEL")
                onClicked: {
                    selected.map(
                        function (id) {
                            measurements.remove(id, false);
                        }
                    )
                    measurements.get()
                }
            }

            MenuItem {
                visible: inSelectMode
                text: qsTr("QUIT_SELECTION_MODE_LABEL")
                onClicked: {
                    selected = [];
                    inSelectMode = false;
                }
            }
        }
        VerticalScrollDecorator {}


        id: book
        anchors.fill: parent
        model: measurements.model
        delegate: ListItem
        {
            enabled: !isTutorialEnabled
            id: measurement
            RemorseItem { id: remorse }
            contentHeight: sugar.height + whenMeasurement.height + Theme.paddingSmall*3
            onClicked: pageStack.push(Qt.resolvedUrl("qrc:/assets/pages/MeasurementDetails.qml"), {
                                          "measurement_id": measurement_id,
                                          "value": value,
                                          "meal": meal,
                                          "timestamp": timestamp
                                      })
            Switch {
                id: listItemCheckbox
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
            menu: ContextMenu
            {
                MenuItem {
                    text: qsTr("SELECT_LABEL")
                    onClicked: {
                        if (!inSelectMode) {
                            selected = [];
                            inSelectMode = true;
                        }
                        listItemCheckbox.checked = true;
                    }
                }
                MenuItem
                {
                    text: qsTr("CHANGE_MEAL_LABEL")
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
                    text: qsTr("REMOVE_LABEL")
                    onClicked: remorse.execute(measurement, qsTr("REMOVE_MEASUREMENT_REMORSE"), function() {
                        measurements.remove(measurement_id)
                    })
                }
            }

            GlassItem
            {
                x: 0
                id: dot
                width: Theme.itemSizeExtraSmall
                height: width
                anchors.verticalCenter: sugar.verticalCenter
                color: thresholds.evaluateMeasurement(value, meal)
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
                color: Theme.primaryColor
            }

            Label
            {
                id: whenMeasurement
                font.pixelSize: Theme.fontSizeSmall
                text: application.mealListModel[meal < 0 ? 4 : meal].name
                color: Theme.secondaryColor
                anchors
                {
                    top: sugar.bottom
                    topMargin: Theme.paddingSmall
                    left: parent.left
                    leftMargin: Theme.horizontalPageMargin
                }
            }

            Label
            {
                id: dateLabel
                font.pixelSize: Theme.fontSizeSmall
                horizontalAlignment: Text.AlignRight
                text: new Date(timestamp*1000).toLocaleString(Qt.locale(), "HH:mm")
                anchors
                {
                    left: whenMeasurement.right
                    right: listItemCheckbox.visible ? listItemCheckbox.left : parent.right
                    rightMargin: Theme.horizontalPageMargin
                    top: parent.top
                    topMargin: Theme.paddingSmall
                }
                color: Theme.highlightColor
            }
        }
    }

    InteractionHintLabel
    {
        text: qsTr("MEASUREMENTS_PULLEY_HINT")
        color: Theme.secondaryColor
        anchors.top: parent.top
        opacity: hint.running ? (pullDownMenu.active ? 0.0 : 1.0) : 0.0
        Behavior on opacity { FadeAnimation {} }
        invert: true
    }

    InteractionHintLabel
    {
        text: qsTr("MEASUREMENTS_ADD_HINT")
        color: Theme.secondaryColor
        anchors.bottom: parent.bottom
        opacity: hint.running ? (pullDownMenu.active ? 1.0 : 0.0) : 0.0
        Behavior on opacity { FadeAnimation {} }
        invert: false
    }

    TouchInteractionHint
    {
        id: hint
        loops: Animation.Infinite
        interactionMode: TouchInteraction.Pull
        direction: TouchInteraction.Down
        Connections {
            target: application
            onIsTutorialEnabledChanged:
            {
                if (application.isTutorialEnabled)
                    hint.start()
                else hint.stop();
            }
        }
    }
}
