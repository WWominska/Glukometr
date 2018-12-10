import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../components"
import ".."

DialogPage
{
    id: calendarPage
    property bool datesChanged: false
    onAccepted: {
        if (datesChanged) {
            application.beginDate = new Date(
                kalednarz.selectedDate.getFullYear(),
                kalednarz.selectedDate.getMonth(),
                kalednarz.selectedDate.getDate(), 0, 0, 0);
            application.endDate = new Date(
                        kadenlarz.selectedDate.getFullYear(),
                        kadenlarz.selectedDate.getMonth(),
                        kadenlarz.selectedDate.getDate(), 23, 59, 59);
            measurements.get({
                "timestamp": [Date.parse(application.endDate)/1000, "<=", Date.parse(application.beginDate)/1000, ">="]
            })
            application.datesSet = true
        }
    }

    title: qsTr("Wybierz przedział")
    background: OreoBackground {}
    Rectangle {
        anchors
        {
            left: parent.left
            right: parent.right
            margins: Theme.horizontalPageMargin
            top: parent.top

        }
        id: begin
        property bool open: false
        color: "#99ff7575"
        width: parent.width
        height: Theme.itemSizeExtraSmall
        MouseArea {
            anchors.fill: parent
            onClicked: {
                begin.open = !begin.open
                end.open = !begin.open
            }
        }

        Label {
            id: poczatek
            text: qsTr("Początek")
            anchors
            {
                left:parent.left
                leftMargin: Theme.horizontalPageMargin
                verticalCenter: parent.verticalCenter
            }
        }
        Label
        {
            anchors
            {
                right: picon.left
                rightMargin: Theme.paddingLarge
                verticalCenter: parent.verticalCenter
            }
            color: "black"
            text: kalednarz.selectedDate.toLocaleDateString(Qt.locale(), "dd-MM-yyyy")
        }

        IconLabel {
            id:picon
            anchors
            {
                right: parent.right
                rightMargin: Theme.horizontalPageMargin
                verticalCenter: parent.verticalCenter
            }
            text: parent.open ? "\ue5c7" : "\ue5c5"
        }
    }

    Rectangle
    {
        color: "transparent"
        anchors {
            top: begin.bottom
            topMargin: Theme.horizontalPageMargin
        }
        height: visible ? kalednarz.height : 0

        visible: begin.open
        id: doWidzenia
        width: parent.width
        CalendarWidget
        {
            id: kalednarz
            selectedDate: application.beginDate
            onSelectedDateChanged: calendarPage.datesChanged = true
            anchors
            {

                left: parent.left
                right: parent.right
                leftMargin: Theme.horizontalPageMargin
                rightMargin: Theme.horizontalPageMargin
            }

            width: parent.width
        }
    }

    Rectangle {
        id: end
        anchors {
            top: doWidzenia.bottom

            left: parent.left
            right: parent.right
            rightMargin: Theme.horizontalPageMargin
            leftMargin: Theme.horizontalPageMargin
            topMargin: Theme.paddingMedium
        }

        property bool open: false
        color: "#99ff7575"
        width: parent.width
        height: Theme.itemSizeExtraSmall
        MouseArea {
            anchors.fill: parent
            onClicked: {
                end.open = !end.open
                begin.open = !end.open
            }
        }

        Label {
            text: qsTr("Koniec")
            anchors
            {
                left:parent.left
                leftMargin: Theme.horizontalPageMargin
                verticalCenter: parent.verticalCenter
            }
        }

        Label
        {
            anchors
            {
                right: kicon.left
                rightMargin: Theme.paddingLarge
                verticalCenter: parent.verticalCenter
            }
            color: "black"
            text: kadenlarz.selectedDate.toLocaleDateString(Qt.locale(), "dd-MM-yyyy")
        }

        IconLabel {
            id: kicon
            anchors
            {
                right: parent.right
                rightMargin: Theme.horizontalPageMargin
                verticalCenter: parent.verticalCenter
            }
            text: parent.open ? "\ue5c7" : "\ue5c5"
        }
    }

    Rectangle
    {
        anchors {
            top: end.bottom
            topMargin: Theme.horizontalPageMargin
        }
        color: "transparent"
        height: visible ? kadenlarz.height : 0

        visible: end.open
        id: doWidzenia2
        width: parent.width
        CalendarWidget
        {
            id: kadenlarz
            selectedDate: application.endDate
            onSelectedDateChanged: calendarPage.datesChanged = true
            anchors
            {

                left: parent.left
                right: parent.right
                leftMargin: Theme.horizontalPageMargin
                rightMargin: Theme.horizontalPageMargin
            }

            width: parent.width
        }
    }
}
