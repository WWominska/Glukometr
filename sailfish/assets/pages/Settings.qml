import QtQuick 2.0
import Sailfish.Silica 1.0

Page
{
    Item {
        id: consts
        property int noText: 0
        property int phoneNumber: 1
    }

    property var settingList: [
        {
            "settingText": qsTr("SETTINGS_THRESHOLDS"),
            "secondaryText": 0,
            "replace": false,
            "source": "qrc:/assets/pages/Thresholds.qml",
            "image": "qrc:/icons/icon-settings-threshold.svg",
            "lightImage": "qrc:/icons/icon-settings-threshold-light.svg",
        },
        {
            "settingText": qsTr("SETTINGS_REMINDERS"),
            "secondaryText": 0,
            "replace": false,
            "source": "qrc:/assets/pages/ReminderList.qml",
            "image": "image://Theme/icon-m-alarm",
            "lightImage": "image://Theme/icon-m-alarm"
        },
        {
            "settingText": qsTr("SETTINGS_PHONE_NUMBER") + ": ",
            "secondaryText": 1,
            "replace": false,
            "source": "qrc:/assets/dialogs/ChangePhoneNumber.qml",
            "image": "image://Theme/icon-m-answer",
            "lightImage": "image://Theme/icon-m-answer"
        },
        {
            "settingText": qsTr("SETTINGS_DRUGS"),
            "secondaryText": 0,
            "replace": false,
            "source": "qrc:/assets/pages/DrugList.qml",
            "image": "qrc:/icons/icon-annotations-drug.svg",
            "lightImage": "qrc:/icons/icon-annotations-drug-light.svg"
        },
        {
            "settingText": qsTr("SETTINGS_TUTORIAL"),
            "secondaryText": 0,
            "replace": true,
            "source": "qrc:/assets/pages/Tutorial.qml",
            "image": "image://Theme/icon-m-question",
            "lightImage": "image://Theme/icon-m-question"
        }
    ]

    id: setting
    SilicaListView
    {
        anchors.fill: parent
        model: settingList

        header: PageHeader
        {
            title: qsTr("SETTINGS_TITLE")
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
                source: application.lightTheme ? model.modelData.lightImage : model.modelData.image
            }
            Label
            {
                id: label
                text: model.modelData.settingText
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
                    switch (model.modelData.secondaryText) {
                    case consts.phoneNumber:
                        return settings.phoneNumber ? settings.phoneNumber : qsTr("SETTINGS_PHONE_NUMBER_PLACEHOLDER");
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

            menu: model.modelData.secondaryText == consts.phoneNumber ? contextMenu : undefined

            ContextMenu {
                id: contextMenu
                MenuItem {
                    enabled: settings.phoneNumber
                    text: qsTr("SETTINGS_PHONE_NUMBER_CALL")
                    onClicked: Qt.openUrlExternally("tel:" + settings.phoneNumber)
                }
            }

            onClicked: {
                if (model.modelData.replace)
                    pageStack.replace(Qt.resolvedUrl(model.modelData.source))
                else pageStack.push(Qt.resolvedUrl(model.modelData.source))
            }
        }
    }
}
