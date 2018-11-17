import QtQuick 2.0
import QtQuick.Controls 2.3
import ".."
import "../components"

Page
{
    header: PageHeader {
        id: pageHeader
        title: qsTr("Ustawienia")
    }
    background: OreoBackground {}

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
            source: "qrc:/assets/pages/Thresholds.qml"
            image: "thresholds"
        }

//        ListElement
//        {
//            settingText: "Przypomnienia"
//            secondaryText: 0
//            replace: false
//            source: "qrc:/assets/pages/ReminderList.qml"
//            image: "bell"
//        }

        ListElement
        {
            settingText: "Telefon: "
            secondaryText: 1
            replace: false
            source: "qrc:/assets/dialogs/ChangePhoneNumber.qml"
            image: "phone"
        }

        ListElement
        {
            settingText: "Leki"
            secondaryText: 0
            replace: false
            source: "qrc:/assets/pages/DrugList.qml"
            image: "needle"
        }
    }

    id: setting
    ListView
    {
        anchors.fill: parent
        model: settingList
        delegate: ItemDelegate
        {
            icon.name: image
            width: parent.width

            Label
            {
                id: label
                text: settingText
                font.pixelSize: Theme.fontSizeMedium
                x: 56
                anchors
                {
                    verticalCenter: parent.verticalCenter
                }
            }
            Label {
                font.pixelSize: Theme.fontSizeMedium
                text:
                {
                    switch (secondaryText) {
                    case consts.phoneNumber:
                        return settings.phoneNumber ? settings.phoneNumber :qsTr("Naciśnij aby ustawić");
                    default: return "";
                    }
                }
                color: "#d9d2b9"

                anchors
                {
                    left: label.right
                    leftMargin: Theme.paddingSmall
                    verticalCenter: parent.verticalCenter
                }
            }

            Menu {
                id: contextMenu
                MenuItem {
                    enabled: settings.phoneNumber
                    text: qsTr("Dzwoń")
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
