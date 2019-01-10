import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

Dialog
{
    id: dialog
    property int meal;
    property real value;
    property alias remind: repeat.checked

    property int tutorialPhase: 0
    property real disabledOpacity: 0.2

    onTutorialPhaseChanged:
    {
        if (tutorialPhase >= 1)
        {
            interactionLabel.anchors.bottom = undefined
            interactionLabel.y = naglowek.contentHeight - Theme.paddingLarge
        } else {
            interactionLabel.anchors.bottom = dialog.bottom
            interactionLabel.y = undefined
        }
    }

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

    onDone:
    {
        if (result === DialogResult.Accepted)
        {
            value = nameField.text
            application.isTutorialEnabled = false
        }
    }

    InteractionHintLabel
    {
        id: interactionLabel
        anchors.bottom: parent.bottom
        visible: application.isTutorialEnabled
        text: {
            switch (tutorialPhase)
            {
            case 0:
                return nameField.focus ? qsTr("ADD_MEASUREMENT_VALUE_INPUT_HINT") : qsTr("ADD_MEASUREMENT_VALUE_TAP_HINT");
            case 1:
                return qsTr("ADD_MEASUREMENT_MEAL_HINT");
            case 2:
                return qsTr("ADD_MEASUREMENT_ACCEPT_HINT");
            }
        }
        invert: tutorialPhase >= 1
    }

    SilicaFlickable
    {
        VerticalScrollDecorator {}
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: column.childrenRect.height

        Column
        {
            id: column
            width: parent.width
            spacing: Theme.paddingSmall

             DialogHeader { id: naglowek }

             SectionHeader
             {
                font.pixelSize: Theme.fontSizeLarge
                text: qsTr("MEASUREMENT_VALUE_LABEL")
                opacity: showIfPhase(0) ? 1.0 : disabledOpacity
             }

             TextField
             {
                 id: nameField
                 width: parent.width
                 placeholderText: "120..."
                 label: qsTr("MEASUREMENT_VALUE_INPUT_LABEL")
                 inputMethodHints: Qt.ImhDigitsOnly
                 validator: IntValidator
                 {
                     bottom: 1
                     top:700
                 }
                 enabled: opacity === 1
                 opacity: showIfPhase(0) ? 1.0 : disabledOpacity
                 onFocusChanged: if (acceptableInput && tutorialPhase == 0) tutorialPhase++
                 TapInteractionHint
                 {
                     running: application.isTutorialEnabled && showIfPhase(0) && !nameField.focus
                     loops: Animation.Infinite
                     anchors.centerIn: parent
                 }
             }

             SectionHeader
             {
                font.pixelSize: Theme.fontSizeLarge
                text: qsTr("MEASUREMENT_MEAL_LABEL")
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
                text: qsTr("MEASUREMENT_MEAL_HELP")
                wrapMode: Text.WordWrap
                color: Theme.secondaryHighlightColor
                enabled: opacity === 1
                opacity: showIfPhase(1) ? 1.0 : disabledOpacity

             }

             Repeater
             {
                 model: application.mealListModel
                 delegate: MealComponent {
                     selected: dialog.meal === model.modelData.meal
                     onClicked:
                     {
                         if (tutorialPhase === 1) tutorialPhase = 2;
                         dialog.meal = model.modelData.meal;
                     }
                 }
             }

             TextSwitch
             {
                 id: repeat
                 anchors
                 {
                     left: parent.left
                     right: parent.right
                 }
                 checked: meal === 1
                 text: qsTr("MEASUREMENT_REMIND_LABEL")
                 description: qsTr("MEASUREMENT_REMIND_HELP")
                 enabled: opacity === 1
                 opacity: showIfPhase(2) ? 1.0 : disabledOpacity
             }
        }
    }
}
