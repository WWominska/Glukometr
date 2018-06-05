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
    property alias drugsUnit: unitDrugs.text
    property alias idDrugs: drugsId.value
    property alias textNotes: notesText.text

    property bool isEdited: false


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
                font.bold: true
                text: "Dodaj notatkę"
            }

            ComboBox
            {
                visible: !isEdited
                id: selectId
                currentIndex: -1
                label: "Rodzaj notatki: "
                value: "Wybierz"
                menu: ContextMenu
                {
                    MenuItem
                    {
                        text: "Posiłek"
                        onClicked: selectId.value=text
                    }

                    MenuItem
                    {
                        text: "Lek"
                        onClicked: selectId.value=text
                    }

                    MenuItem
                    {
                        text: "Notatka tekstowa"
                        onClicked: selectId.value=text
                    }
                }
            }

            TextField
            {
                id: nameOfFood
                visible: selectId.currentIndex == 0
                width: parent.width
                placeholderText: "Schabowy"
                label: "Co zjadłeś przed pomiarem?"
            }

            TextField
            {
                id: unitFood
                visible: selectId.currentIndex == 0
                width: parent.width
                inputMethodHints: Qt.ImhDigitsOnly
                placeholderText: "200"
                label: "Ile zjadłeś?"
            }

            ComboBox
            {
                id: unitId
                visible: selectId.currentIndex == 0
                currentIndex: 0
                label: "Jednostka: "
                value: "Wybierz"
                menu: ContextMenu
                {
                    MenuItem
                    {
                        text: "g"
                        onClicked: unitId.value=text
                    }

                    MenuItem
                    {
                        text: "ml"
                        onClicked: unitId.value=text
                    }

                    MenuItem
                    {
                        text: "sztuk"
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
                label: "Lek "
                value: "Wybierz"
                menu: ContextMenu
                {
                    Repeater
                    {
                        model: pythonGlukometr.drugs.model
                        MenuItem
                        {
                            text: name
                            onClicked:
                            {
                                drugsName.drugId = id
                                drugsName.value = text
                            }
                        }
                    }
                    MenuItem
                    {
                        text: "Dodaj własny lek"
                        onClicked:
                        {
                            var dialog = pageStack.push(Qt.resolvedUrl("AddDrugs.qml"))
                            dialog.accepted.connect(function()
                            {
                                pythonGlukometr.drugs.add({"name": dialog.value})
                            })
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
                placeholderText: "6"
                label: "Ile przyjąłeś?"
            }

            ComboBox
            {
                id: drugsId
                visible: selectId.currentIndex == 1
                currentIndex: 1
                label: "Jednostka: "
                value: "Wybierz"
                menu: ContextMenu
                {
                    MenuItem
                    {
                        text: "dm/L"
                        onClicked: unitId.value=text
                    }

                    MenuItem
                    {
                        text: "g"
                        onClicked: unitId.value=text
                    }

                    MenuItem
                    {
                        text: "ml"
                        onClicked: unitId.value=text
                    }

                    MenuItem
                    {
                        text: "sztuk"
                        onClicked: unitId.value=text
                    }
                }
            }

            TextField
            {
                id: notesText
                visible: selectId.currentIndex == 2
                width: parent.width
                placeholderText: "Jeździłem na rowerze przez 30 min"
                label: "Uwagi, aktywność fizyczna"
            }

        }
    }
}
