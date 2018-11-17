import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import Qt.labs.calendar 1.0

Item {
    property var date: new Date()
    property var selectedDate: new Date()

    RowLayout {
        id: calendarNav
        width: parent.width
        Label {
            text: date.toLocaleDateString(Qt.locale(), "MMMM yyyy")
        }
        Item {
            Layout.fillWidth: true
        }
        Button {
            text: "<"
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
        Button {
            text: ">"
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
                color: "#fff"
                text: model.shortName
            }
        }

        MonthGrid {
            id: grid
            width: parent.width
            month: date.getMonth()
            year: date.getFullYear()
            locale: Qt.locale()

            delegate: ToolButton {
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
        anchors {
            top: calendarGrid.bottom
            horizontalCenter: parent.horizontalCenter
        }

        text: selectedDate.toLocaleDateString(Qt.locale(), "dd MMMM yyyy")
    }
}
