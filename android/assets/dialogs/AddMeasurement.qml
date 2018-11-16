import QtQuick 2.9
import QtQuick.Controls 2.3
import QtGraphicalEffects 1.0
import ".."
import "../components"

DialogPage
{
    id: dialog

    footer: DialogHeader {}
    header: PageHeader {
        id: pageHeader
        title: "Dodaj pomiar"
    }

    property int meal: 4
    property alias value: nameField.text
    property real value;
    property bool remind: false
    property bool result: false

    //property alias remind: repeat.checked

    property int tutorialPhase: 0
    property real disabledOpacity: 0.2

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

    Flickable
    {
        ScrollBar.vertical: ScrollBar { }
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: column.childrenRect.height

        Column
        {
            id: column
            width: parent.width

             SectionHeader
             {
                font.pixelSize: Theme.fontSizeLarge
                text: "Podaj cukier"

                opacity: showIfPhase(0) ? 1.0 : disabledOpacity
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
                color: "#d9d2b9"
                wrapMode: Text.WordWrap
                enabled: opacity === 1
                opacity: showIfPhase(1) ? 1.0 : disabledOpacity

             }

             Repeater
             {
                 model: application.mealListModel
                 delegate: ItemDelegate
                 {
                     Connections {
                         target: dialog
                         onMealChanged: checkIcon.visible = dialog.meal == meal
                     }
                     icon.name: iconSource
                     highlighted: checkIcon.visible
                     width: parent.width
                     IconLabel
                     {
                         id: checkIcon
                         text: "\ue86c"
                         font.pixelSize: 32
                         visible: dialog.meal == meal
                         anchors
                         {
                             right: parent.right
                             rightMargin: Theme.horizontalPageMargin
                             verticalCenter: parent.verticalCenter
                         }
                     }
                     text: name
                     onClicked: dialog.meal = meal;
                 }
             }

//             CheckBox
//             {
//                 id: repeat
//                 anchors
//                 {
//                     left: parent.left
//                     margins: Theme.horizontalPageMargin
//                     right: parent.right
//                 }
//                 checked: meal === 1
//                 text: "Przypomnij za 2 godziny"
//                 enabled: opacity === 1
//                 opacity: showIfPhase(2) ? 1.0 : disabledOpacity
//             }
//             Label {
//                 anchors
//                 {
//                     left: parent.left
//                     leftMargin: Theme.paddingLarge
//                     //right: parent.right
//                 }
//                 color: "#d9d2b9"
//                 text: "Przypomnienie uaktywni się za 2 godziny"
//             }
        }
    }
}
