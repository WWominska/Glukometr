import QtQuick 2.0
import Sailfish.Silica 1.0


Dialog
{
    id: calendarPage
    property bool datesChanged: false
    property var beginDate: application.beginDate
    property var endDate: application.endDate
    onAccepted: {
        if (datesChanged) {
            application.beginDate = new Date(
                calendarPage.beginDate.getFullYear(),
                calendarPage.beginDate.getMonth(),
                calendarPage.beginDate.getDate(), 0, 0, 0);
            application.endDate = new Date(
                calendarPage.endDate.getFullYear(),
                calendarPage.endDate.getMonth(),
                calendarPage.endDate.getDate(), 23, 59, 59);
            measurements.get({
                "timestamp": [Date.parse(application.endDate)/1000, "<=", Date.parse(application.beginDate)/1000, ">="]
            })
            application.datesSet = true
        }
    }

    SilicaFlickable {
        VerticalScrollDecorator {}
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: column.childrenRect.height

        Column
        {
            id:column
            width: parent.width
            spacing: Theme.paddingSmall

            DialogHeader {id: header}

            SectionHeader
            {
                font.pixelSize: Theme.fontSizeLarge
                text: qsTr("CALENDAR_TITLE")
            }

            ExpandingSectionGroup
            {
                currentIndex: 0
                ExpandingSection
                {
                    title: qsTr("CALENDAR_BEGIN") + " (" + calendarPage.beginDate.toLocaleDateString(Qt.locale(), "dd-MM-yyyy") + ")"
                    content.sourceComponent: Column {
                        DatePicker {
                            id: kalednarz
                            date: calendarPage.beginDate
                            onDateChanged: {
                                calendarPage.beginDate = date
                                calendarPage.datesChanged = true
                            }
                        }
                    }
                }
                ExpandingSection
                {
                    title: qsTr("CALENDAR_END") + " (" + calendarPage.endDate.toLocaleDateString(Qt.locale(), "dd-MM-yyyy") + ")"
                    content.sourceComponent: DatePicker {
                        id: kadenlarz
                        date: calendarPage.endDate
                        onDateChanged: {
                            calendarPage.endDate = date
                            calendarPage.datesChanged = true
                        }
                    }
                }
            }
        }
    }
}
