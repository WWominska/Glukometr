import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0

Page
{
    ConfigurationGroup {
        id: settings
        path: "/apps/harbour-glukometr"
        property string phoneNumber: ""
    }

    ListModel
    {
        id: settingList
        ListElement
        {
            settingText: "Progi"
            source: "Threshold.qml"
            image: "qrc:/icons/icon-settings-threshold.svg"
        }

        ListElement
        {
            settingText: "Przypomnienia"
            source: "RemindersPage.qml"
            image: "image://Theme/icon-m-alarm"
        }

        ListElement
        {
            settingText: "Telefon: "
            source: "emergency.qml"
            image: "image://Theme/icon-m-answer"
        }

        ListElement
        {
            settingText: "Leki"
            source: "DrugsPage.qml"
            image: "qrc:/icons/icon-annotations-drug.svg"
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
                    if (settingText == "Telefon")
                        return settings.phoneNumber;
                    return "";
                }
                color: Theme.highlightColor

                anchors
                {
                    left: label.right
                    leftMargin: Theme.paddingMedium
                    verticalCenter: parent.verticalCenter
                }
            }

            onClicked: pageStack.push(Qt.resolvedUrl(source))
        }
    }
}
