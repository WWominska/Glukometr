import QtQuick 2.0
import Sailfish.Silica 1.0

Page
{
    Item {
        id: consts
        property int noText: 0
        property int phoneNumber: 1
    }

    ListModel
    {
        id: settingList
        ListElement
        {
            settingText: "Progi"
            secondaryText: 0
            replace: false
            source: "Threshold.qml"
            image: "qrc:/icons/icon-settings-threshold.svg"
        }

        ListElement
        {
            settingText: "Przypomnienia"
            secondaryText: 0
            replace: false
            source: "RemindersPage.qml"
            image: "image://Theme/icon-m-alarm"
        }

        ListElement
        {
            settingText: "Telefon: "
            secondaryText: 1
            replace: false
            source: "emergency.qml"
            image: "image://Theme/icon-m-answer"
        }

        ListElement
        {
            settingText: "Leki"
            secondaryText: 0
            replace: false
            source: "DrugsPage.qml"
            image: "qrc:/icons/icon-annotations-drug.svg"
        }
        ListElement
        {
            secondaryText: 0
            settingText: "Rozpocznij tutorial"
            source: "Tutorial.qml"
            replace: true
            image: "image://Theme/icon-m-question"

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
                width: Theme.iconSizeMedium
                height: Theme.iconSizeMedium
                sourceSize.width: width
                sourceSize.height: height
                smooth: true
                source: image
            }

            Label
            {
                id: label
                text: settingText
                anchors
                {
                    left: icon.right
                    leftMargin: Theme.paddingMedium
                    verticalCenter: parent.verticalCenter
                }
            }
            Label {
                text:
                {
                    switch (secondaryText) {
                    case consts.phoneNumber:
                        return settings.phoneNumber ? settings.phoneNumber : "Naciśnij aby ustawić";
                    default: return "";
                    }
                }
                color: Theme.highlightColor

                anchors
                {
                    left: label.right
                    leftMargin: Theme.paddingMedium
                    verticalCenter: parent.verticalCenter
                }
            }

            onClicked: {
                if (replace)
                    pageStack.replace(Qt.resolvedUrl(source))
                else pageStack.push(Qt.resolvedUrl(source))
            }
        }
    }
}
