import QtQuick 2.0
import QtQuick.Controls 2.3
import ".."
import "../components"

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
            source: "" //"qrc:/assets/pages/Thresholds.qml"
            image: "qrc:/icons/icon-settings-threshold.svg"
        }

        ListElement
        {
            settingText: "Przypomnienia"
            secondaryText: 0
            replace: false
            source: "" // "qrc:/assets/pages/ReminderList.qml"
            image: "qrc:/icons/icon-m-alarm.svg"
        }

        ListElement
        {
            settingText: "Telefon: "
            secondaryText: 1
            replace: false
            source: "qrc:/assets/dialogs/ChangePhoneNumber.qml"
            image: "qrc:/icons/icon-l-answer.svg"
        }

        ListElement
        {
            settingText: "Leki"
            secondaryText: 0
            replace: false
            source: "" // "qrc:/assets/pages/DrugList.qml"
            image: "qrc:/icons/icon-annotations-drug.svg"
        }
        ListElement
        {
            secondaryText: 0
            settingText: "Rozpocznij tutorial"
            source: "qrc:/assets/pages/Tutorial.qml"
            replace: true
            image: "qrc:/icons/icon-m-question.svg"

        }
    }

    id: setting
    ListView
    {
        anchors.fill: parent
        model: settingList

        header: PageHeader
        {
            title: "Ustawienia"
        }

        delegate: ItemDelegate
        {
            width: parent.width
            height: 48
            Image
            {
                id: icon
                anchors
                {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: Theme.horizontalPageMargin
                }
                width: 32
                height: 32
                sourceSize {
                    width: 32
                    height: 32
                }
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

            Menu {
                id: contextMenu
                MenuItem {
                    enabled: settings.phoneNumber
                    text: "Dzwoń"
                    onClicked: Qt.openUrlExternally("tel:+48" + settings.phoneNumber)
                }
            }
            onPressAndHold: if(secondaryText == consts.phoneNumber) contextMenu.popup()

            onClicked: {
                if (replace)
                    pageStack.replace(Qt.resolvedUrl(source))
                else pageStack.push(Qt.resolvedUrl(source))
            }
        }
    }
}
