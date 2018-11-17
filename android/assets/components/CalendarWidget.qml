import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.3
import Qt.labs.calendar 1.0
import "../components"
import ".."


Item {
    property var date: new Date()
    property var selectedDate: new Date()
    height: calendarNav.height + calendarGrid.childrenRect.height + napiz.height + Theme.paddingMedium

    RowLayout {
        id: calendarNav
        width: parent.width

        Label {
            text: date.toLocaleDateString(Qt.locale(), "MMMM yyyy")
            font.pixelSize: Theme.fontSizeMedium
        }
        Item {
            Layout.fillWidth: true
        }
        RoundButton {
            background: Rectangle
            {
                color: "#99ff7575"
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                height: parent.width
                radius: parent.width
            }
            text: "\ue5cb"
            font.family: "Material Icons"
            onClicked: {
                var d = new Date();
                d.setDate(date.getDate());
                if (date.getMonth() > 0)
                    d.setMonth(date.getMonth() - 1);
                else {
                    d.setMonth(11)
                    d.setFullYear(date.getFullYear() - 1)
                }
                date = d;
            }
        }
        RoundButton {
            background: Rectangle
            {
                color: "#99ff7575"
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                height: parent.width
                radius: parent.width
            }

            text: "\ue5cc"
            font.family: "Material Icons"

            onClicked: {
                var d = new Date();
                d.setDate(date.getDate());
                if (date.getMonth() < 11)
                    d.setMonth(date.getMonth() + 1);
                else {
                    d.setMonth(0)
                    d.setFullYear(date.getFullYear() + 1)
                }
                date = d;
            }
        }
    }

    Column {
        id: calendarGrid
        width: parent.width
        anchors.top: calendarNav.bottom

        DayOfWeekRow {
            locale: grid.locale
            width: parent.width
            delegate: Label {
                width: parent.width/7
                horizontalAlignment: Text.AlignHCenter
                color: "#ff7575"
                text: model.shortName
                font.pixelSize: Theme.fontSizeExtraSmall
            }
        }

        MonthGrid {
            id: grid
            width: parent.width
            month: date.getMonth()
            year: date.getFullYear()
            locale: Qt.locale()
            spacing: 0


            delegate: ToolButton {
                background: Rectangle {
                    anchors.fill: parent
                    color: "#85000000"
                }
                //Material.foreground: "black"

                opacity: model.month === grid.month ? 1.0 : 0.6
                text: model.day

                onClicked: {
                    var d = new Date();
                    d.setFullYear(model.year)
                    d.setMonth(model.month)
                    d.setDate(model.day)
                    selectedDate = d;
                }
            }
        }
    }
    Label {
        id: napiz
        anchors
        {
            top: calendarGrid.bottom
            topMargin: Theme.paddingSmall
            bottomMargin:Theme.paddingLarge
            horizontalCenter: parent.horizontalCenter
        }

        text: selectedDate.toLocaleDateString(Qt.locale(), "dd MMMM yyyy")
        color: "#ff7575"
    }
}
