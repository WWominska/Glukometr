import QtQuick 2.0
import QtQuick.Controls 2.3
import QtGraphicalEffects 1.0
import glukometr 1.0
import ".."
import "../components"

DialogPage
{
    id: dialog
    property int meal;
    header: DialogHeader { id: naglowek }

    Column
    {
        width: parent.width


        Repeater
        {
            model: ListModel
            {
                ListElement
                {
                    meal: 0
                    iconSource: "qrc:/icons/icon-fasting.svg"
                    name: "Na czczo"
                }

                ListElement
                {
                    meal: 1
                    iconSource: "qrc:/icons/icon-before-meal.svg"
                    name: "Przed posiłkiem"
                }

                ListElement
                {
                    meal: 2
                    iconSource: "qrc:/icons/icon-after-meal.svg"
                    name: "Po posiłku"
                }

                ListElement
                {
                    meal: 3
                    iconSource: "qrc:/icons/icon-m-night.svg"
                    name: "Nocna"
                }

                ListElement
                {
                    meal: 4
                    iconSource: "qrc:/icons/icon-m-question.svg"
                    name: "Nie określono"
                }
            }

            delegate: ItemDelegate
            {
                Connections {
                    target: dialog
                    onMealChanged: checkIcon.visible = dialog.meal == meal
                }
                highlighted: checkIcon.visible
                height: mealIcon.height + 20

                width: parent.width
                Image
                {
                    id: mealIcon
                    source: iconSource
                    sourceSize {
                        width: 32
                        height: 32
                    }

                    width: 32
                    height: 32
                    anchors
                    {
                        left: parent.left
                        leftMargin: Theme.horizontalPageMargin
                        verticalCenter: parent.verticalCenter
                    }
                }

                Image
                {
                    id: checkIcon
                    source: "qrc:/icons/icon-m-acknowledge.svg"
                    sourceSize {
                        width: 32
                        height: 32
                    }
                    visible: dialog.meal == meal
                    width: 32
                    height: 32
                    anchors
                    {
                        right: parent.right
                        rightMargin: Theme.horizontalPageMargin
                        verticalCenter: parent.verticalCenter
                    }
                }

                Label
                {
                    anchors
                    {
                       left: mealIcon.right
                       verticalCenter: parent.verticalCenter
                       leftMargin: Theme.paddingMedium
                    }
                    text: name
                }

                onClicked: { dialog.meal = meal; dialog.accept() }
            }
        }
    }
}
