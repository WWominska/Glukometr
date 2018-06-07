import QtQuick 2.0
import Sailfish.Silica 1.0

Page
{
    ListModel
    {
        id: settingList
        ListElement
        {
            settingText: "Progi"
            source: "Threshold.qml"
            image: "image://Theme/icon-m-alarm"
        }

        ListElement
        {
            settingText: "Przypomnienia"
            source: "RemindersPage.qml"
            image: "image://Theme/icon-m-alarm"
        }

        ListElement
        {
            settingText: "Telefon"
            source: "emergency.qml"
            image: "image://Theme/icon-l-answer"
        }

        ListElement
        {
            settingText: "Leki"
            source: "DrugsPage.qml"
            image: "image://Theme/icon-m-alarm"
        }
    }

    id: setting
    SilicaListView
    {
        anchors.fill: parent
        model: settingList

        header: PageHeader
        {
            title: "Ustawienia"
        }

        delegate: ListItem
        {
            Image
            {
                id: icon
                anchors
                {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: Theme.horizontalPageMargin
                }
                source: image
            }

            Label
            {
                text: settingText
                anchors
                {
                    left: icon.right
                    leftMargin: Theme.paddingMedium
                    verticalCenter: parent.verticalCenter
                }
            }
            onClicked: pageStack.push(Qt.resolvedUrl(source))
        }
    }
}
