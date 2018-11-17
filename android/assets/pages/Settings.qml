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

    property var settingList: [
        {
            "settingText": qsTr("Progi"),
            "secondaryText": 0,
            "replace": false,
            "source": "qrc:/assets/pages/Thresholds.qml",
            "image": "thresholds"
        },
        {
            "settingText": qsTr("Telefon: "),
            "secondaryText": 1,
            "replace": false,
            "source": "qrc:/assets/dialogs/ChangePhoneNumber.qml",
            "image": "phone"
        },
        {
            "settingText": qsTr("Leki"),
            "secondaryText": 0,
            "replace": false,
            "source": "qrc:/assets/pages/DrugList.qml",
            "image": "needle"
        },
    ]

    id: setting
    ListView
    {
        anchors.fill: parent
        model: settingList
        delegate: ItemDelegate
        {
            icon.name: model.modelData.image
            width: parent.width

            Label
            {
                id: label
                text: model.modelData.settingText
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
                    switch (model.modelData.secondaryText) {
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
            onPressAndHold: if(model.modelData.secondaryText == consts.phoneNumber) contextMenu.popup()

            onClicked: {
                if (model.modelData.replace)
                    pageStack.replace(Qt.resolvedUrl(model.modelData.source))
                else pageStack.push(Qt.resolvedUrl(model.modelData.source))
            }
        }
    }
}
