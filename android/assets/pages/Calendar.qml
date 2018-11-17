import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import "../components"
import ".."

Page
{
    header: PageHeader
    {
        id: pageHeader
        title: qsTr("Wybierz przedział")
    }
    background: OreoBackground {}
    Rectangle {
        anchors
        {
            left: parent.left
            right: parent.right
            margins: Theme.horizontalPageMargin
//            rightMargin: Theme.horizontalPageMargin
//            leftMargin: Theme.horizontalPageMargin
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
            text: qsTr("Data początkowa")
            anchors
            {
                left:parent.left
                leftMargin: Theme.horizontalPageMargin
                verticalCenter: parent.verticalCenter
            }
        }
        IconLabel {
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
            text: qsTr("Data końcowa")
            anchors
            {
                left:parent.left
                leftMargin: Theme.horizontalPageMargin
                verticalCenter: parent.verticalCenter
            }
        }
        IconLabel {
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
