import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog
{
    id:addNotes
    property alias noteType: selectId.currentIndex
    property alias foodName: nameOfFood.text
    property alias foodAmount: unitFood.text
    property alias foodUnit: unitId.value
    property alias drugId: drugsName.drugId
    property alias drugName: drugsName.value
    property alias drugsUnit: unitDrugs.text
    property alias idDrugs: drugsId.value
    property alias textNotes: notesText.text

    property bool isEdited: false


    canAccept: (selectId.currentIndex == 0 && nameOfFood.text != "" && unitFood.acceptableInput)
               || (selectId.currentIndex == 1 && drugsName.text !== "" && unitDrugs.acceptableInput)
               || (selectId.currentIndex == 2 && notesText.text !="")

    //

    SilicaFlickable
    {
        VerticalScrollDecorator {}
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: column.childrenRect.height

        Column
        {
            id:column
            width: parent.width
            spacing: Theme.paddingSmall

            DialogHeader {id: header}

            SectionHeader
            {
                id: addNotesHeader
                font.pixelSize: Theme.fontSizeLarge
                text: qsTr("ADD_NOTES_TITLE")
            }

            ComboBox
            {
                visible: !isEdited
                id: selectId
                currentIndex: -1
                label: qsTr("NOTE_TYPE_LABEL")
                value: qsTr("COMBOBOX_PLACEHOLDER")
                menu: ContextMenu
                {
                    MenuItem
                    {
                        text: qsTr("NOTE_MEAL")
                        onClicked: selectId.value=text
                    }

                    MenuItem
                    {
                        text: qsTr("NOTE_DRUG")
                        onClicked: selectId.value=text
                    }

                    MenuItem
                    {
                        text: qsTr("NOTE_TEXT")
                        onClicked: selectId.value=text
                    }
                }
            }

            TextField
            {
                id: nameOfFood
                visible: selectId.currentIndex == 0
                width: parent.width
                placeholderText: qsTr("NOTE_MEAL_NAME_PLACEHOLDER")
                label: qsTr("NOTE_MEAL_NAME_LABEL")
            }

            TextField
            {
                id: unitFood
                visible: selectId.currentIndex == 0
                width: parent.width
                inputMethodHints: Qt.ImhDigitsOnly
                placeholderText: "200"
                label: qsTr("NOTE_MEAL_AMOUNT_LABEL")
                validator: IntValidator
                {
                    bottom: 1
                }
            }

            ComboBox
            {
                id: unitId
                visible: selectId.currentIndex == 0
                currentIndex: 0
                label: qsTr("NOTE_UNIT_LABEL")
                value: "g"
                menu: ContextMenu
                {
                    MenuItem
                    {
                        text: qsTr("NOTE_UNIT_GRAM")
                        onClicked: unitId.value=text
                    }

                    MenuItem
                    {
                        text: qsTr("NOTE_UNIT_ML")
                        onClicked: unitId.value=text
                    }

                    MenuItem
                    {
                        text: qsTr("NOTE_UNIT_UNITS")
                        onClicked: unitId.value=text
                    }
                }
            }

            ComboBox
            {
                id: drugsName
                visible: selectId.currentIndex == 1
                property int drugId
                currentIndex: 0
                label: qsTr("NOTE_DRUG")
                value: qsTr("COMBOBOX_PLACEHOLDER")
                menu: ContextMenu
                {
                    Repeater
                    {
                        model: drugs.model
                        MenuItem
                        {
                            text: name
                            onClicked:
                            {
                                drugsName.drugId = drug_id
                                drugsName.value = text
                            }
                        }
                    }
                }
            }

            TextField
            {
                id: unitDrugs
                visible: selectId.currentIndex == 1
                width: parent.width
                inputMethodHints: Qt.ImhDigitsOnly
                validator: IntValidator
                {
                    bottom: 1
                }
                placeholderText: "6"
                label: qsTr("NOTE_DRUG_AMOUNT_LABEL")
            }

            ComboBox
            {
                id: drugsId
                visible: selectId.currentIndex == 1
                currentIndex: 0
                label: qsTr("NOTE_UNIT_LABEL")
                value: qsTr("NOTE_UNIT_DM_L")
                menu: ContextMenu
                {
                    MenuItem
                    {
                        text: qsTr("NOTE_UNIT_DM_L")
                        onClicked: drugsId.value=text
                    }

                    MenuItem
                    {
                        text: qsTr("NOTE_UNIT_GRAM")
                        onClicked: drugsId.value=text
                    }

                    MenuItem
                    {
                        text: qsTr("NOTE_UNIT_ML")
                        onClicked: drugsId.value=text
                    }

                    MenuItem
                    {
                        text: qsTr("NOTE_UNIT_UNITS")
                        onClicked: drugsId.value=text
                    }
                }
            }

            TextField
            {
                id: notesText
                visible: selectId.currentIndex == 2
                width: parent.width
                placeholderText: qsTr("NOTE_TEXT_STRING_PLACEHOLDER")
                label: qsTr("NOTE_TEXT_STRING_LABEL")
            }

        }
    }
}
