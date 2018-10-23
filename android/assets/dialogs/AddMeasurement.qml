import QtQuick 2.9
import QtQuick.Controls 2.3
import QtGraphicalEffects 1.0
import ".."
import "../components"

DialogPage
{
    id: dialog
    property int meal: 4
    property alias value: nameField.text
    property real value;
    property bool remind: false
    property bool result: false

    property alias remind: repeat.checked

    property int tutorialPhase: 0
    property real disabledOpacity: 0.2

    /*onTutorialPhaseChanged:
    {
        if (tutorialPhase >= 1)
        {
            interactionLabel.anchors.bottom = undefined
            interactionLabel.y = naglowek.contentHeight - Theme.paddingLarge
        } else {
            interactionLabel.anchors.bottom = dialog.bottom
            interactionLabel.y = undefined
        }
    }*/

    canAccept: nameField.acceptableInput

    Component.onCompleted: application.measurementPageOpen = true
    Component.onDestruction: application.measurementPageOpen = false

    function showIfPhase(phase)
    {
        if (application.isTutorialEnabled)
        {
            return tutorialPhase === phase;
        }
        return true
    }

    /*InteractionHintLabel
    {
        id: interactionLabel
        anchors.bottom: parent.bottom
        visible: application.isTutorialEnabled
        text: {
            switch (tutorialPhase)
            {
            case 0:
                return nameField.focus ? "Wpisz wartosć i stuknij w dowolnym miejscu na ekranie" : "Tutaj możesz wpisać wartość cukru. Stuknij w tym miejscu";
            case 1:
                return "Każdy pomiar może mieć ustaloną porę. Stuknij by wybrać";
            case 2:
                return "Naciśnij 'Akceptuj' by dodać pomiar";
            }
        }
        invert: tutorialPhase >= 1
    }*/

    header: DialogHeader {
        id: naglowek
    }

    Flickable
    {
        // VerticalScrollDecorator {}
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: column.childrenRect.height

        Column
        {
            id: column
            width: parent.width
            spacing: Theme.paddingSmall


             SectionHeader
             {
                font.pixelSize: Theme.fontSizeLarge
                text: "Podaj cukier"
                opacity: showIfPhase(0) ? 1.0 : disabledOpacity
             }

             Label
             {
                anchors
                {
                    left: parent.left
                    margins: Theme.horizontalPageMargin
                    right: parent.right
                }
                text: "Wartość cukru"
                wrapMode: Text.WordWrap
                enabled: opacity === 1
                opacity: showIfPhase(1) ? 1.0 : disabledOpacity

             }

             TextField
             {
                 anchors {
                     left: parent.left
                     leftMargin: Theme.horizontalPageMargin
                     right: parent.right
                     rightMargin: Theme.horizontalPageMargin
                 }

                 id: nameField
                 placeholderText: "120..."
                 inputMethodHints: Qt.ImhDigitsOnly
                 validator: IntValidator
                 {
                     bottom: 1
                     top:700
                 }
                 enabled: opacity === 1
                 opacity: showIfPhase(0) ? 1.0 : disabledOpacity
                 onFocusChanged: if (acceptableInput && tutorialPhase == 0) tutorialPhase++
                 /*TapInteractionHint
                 {
                     running: application.isTutorialEnabled && showIfPhase(0) && !nameField.focus
                     loops: Animation.Infinite
                     anchors.centerIn: parent
                 }*/
             }

             SectionHeader
             {
                font.pixelSize: Theme.fontSizeLarge
                text: "Pora posiłku"
                opacity: showIfPhase(1) ? 1.0 : disabledOpacity
             }

             Label
             {
                anchors
                {
                    left: parent.left
                    margins: Theme.horizontalPageMargin
                    right: parent.right
                }
                text: "Poniżej możesz ustawić pore w jakiej dokonałeś pomiaru"
                wrapMode: Text.WordWrap
                enabled: opacity === 1
                opacity: showIfPhase(1) ? 1.0 : disabledOpacity

             }

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
                     // enabled: opacity === 1
                     //opacity: showIfPhase(1) ? 1.0 : disabledOpacity
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
                     onClicked:
                     {
                         // if (tutorialPhase === 1) tutorialPhase = 2;
                         dialog.meal = meal;
                     }
                 }
             }

             CheckBox
             {
                 id: repeat
                 anchors
                 {
                     left: parent.left
                     margins: Theme.horizontalPageMargin
                     right: parent.right
                 }
                 checked: meal === 1
                 text: "Przypomnij za 2 godziny"
                 enabled: opacity === 1
                 opacity: showIfPhase(2) ? 1.0 : disabledOpacity
             }
             Label {
                 anchors
                 {
                     left: parent.left
                     margins: Theme.horizontalPageMargin
                     right: parent.right
                 }
                 text: "Przypomnienie uaktywni się za 2 godziny"
             }
        }
    }
}
