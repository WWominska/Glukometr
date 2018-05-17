import QtQuick 2.0
import Sailfish.Silica 1.0
import QtGraphicalEffects 1.0

Dialog
{
    id: dialog
    property int meal;

    Column
    {
        width: parent.width
        DialogHeader { id: naglowek }

        Repeater
        {
            model: ListModel
            {
                ListElement
                {
                    meal: 0
                    icon: "qrc:/icons/icon-fasting.svg"
                    name: "Na czczo"
                }

                ListElement
                {
                    meal: 1
                    icon: "qrc:/icons/icon-before-meal.svg"
                    name: "Przed posiłkiem"
                }

                ListElement
                {
                    meal: 2
                    icon: "qrc:/icons/icon-after-meal.svg"
                    name: "Po posiłku"
                }

                ListElement
                {
                    meal: 3
                    icon: "image://Theme/icon-m-night"
                    name: "Nocna"
                }

                ListElement
                {
                    meal: 4
                    icon: "image://Theme/icon-m-question"
                    name: "Nie określono"
                }
            }

            delegate: ListItem
            {
                Image
                {
                    id: mealIcon
                    source: icon
                    width: Theme.iconSizeMedium
                    height: width
                    anchors
                    {
                        left: parent.left
                        leftMargin: Theme.horizontalPageMargin
                        top: parent.top
                        topMargin: Theme.paddingSmall
                    }
                }

                ColorOverlay
                {
                     anchors.fill: mealIcon
                     source: mealIcon
                     color: "#ffffff"
                }

                Image
                {
                    id: checkIcon
                    source: "image://Theme/icon-m-acknowledge"
                    visible: dialog.meal == meal
                    width: Theme.iconSizeMedium
                    height: width
                    anchors
                    {
                        right: parent.right
                        rightMargin: Theme.horizontalPageMargin
                        top: parent.top
                        topMargin: Theme.paddingSmall
                    }
                }

                ColorOverlay
                {
                     anchors.fill: checkIcon
                     source: checkIcon
                     visible: checkIcon.visible
                     color: Theme.highlightColor
                }

                Label
                {
                    anchors
                    {
                       left: mealIcon.right
                       verticalCenter: parent.verticalCenter
                       leftMargin: Theme.paddingMedium
                    }
                    font.pixelSize: Theme.fontSizeMedium
                    color: "#ffffff"
                    text: name
                }

                onClicked: { dialog.meal = meal; dialog.accept() }
            }
        }
    }
}
