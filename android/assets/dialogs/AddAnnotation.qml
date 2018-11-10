import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import ".."
import "../components"

DialogPage
{
    id:addNotes
    footer: DialogHeader {}
    header: PageHeader {
        id: pageHeader
        title: "Dodaj notatkę"
    }
    property alias noteType: selectId.currentIndex
    property alias foodName: nameOfFood.text
    property alias foodAmount: unitFood.text
    property alias foodUnit: unitId.currentText
    property alias drugId: drugsName.drugId
    property alias drugName: drugsName.currentText
    property alias drugsUnit: unitDrugs.text
    property alias idDrugs: drugsId.currentText
    property alias textNotes: notesText.text

    property bool isEdited: false


    canAccept: (selectId.currentIndex == 0 && nameOfFood.text != "" && unitFood.acceptableInput)
               || (selectId.currentIndex == 1 && drugsName.text !== "" && unitDrugs.acceptableInput)
               || (selectId.currentIndex == 2 && notesText.text !="")

    //

    Flickable
    {
        ScrollBar.vertical: ScrollBar { }
        anchors.fill: parent
        anchors.topMargin: Theme.paddingMedium
        contentWidth: parent.width
        contentHeight: column.childrenRect.height

        Column
        {
            id:column
            width: parent.width
            spacing: Theme.paddingSmall

            ComboBox {
                id: selectId
                Material.foreground: "#fff"
                Material.background: "#55737373"
                Material.theme: Material.Light
                model: ["Posiłek", "Lek", "Notatka tekstowa"]
               anchors {
                   left: parent.left
                   leftMargin: Theme.horizontalPageMargin
                   right: parent.right
                   rightMargin: Theme.horizontalPageMargin
               }
            }

            Label
            {
                id: mealAfterMeasurement
                anchors
                {
                   left: parent.left
                   leftMargin: Theme.horizontalPageMargin
                   right: parent.right
                   rightMargin: Theme.horizontalPageMargin
                }
                visible: selectId.currentIndex == 0
                font.pixelSize: Theme.fontSizeMedium
                color: "#e3decb"
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: "Co zjadłeś przed pomiarem?"
            }

            TextField
            {
                id: nameOfFood
                anchors {
                    left: parent.left
                    leftMargin: Theme.horizontalPageMargin
                    right: parent.right
                    rightMargin: Theme.horizontalPageMargin
                }
                visible: selectId.currentIndex == 0
                width: parent.width
                placeholderText: "Schabowy"
                color: "#f7f5f0"
            }

            Label
            {
                id: howMuchYouEat
                anchors
                {
                   left: parent.left
                   leftMargin: Theme.horizontalPageMargin
                   right: parent.right
                   rightMargin: Theme.horizontalPageMargin
                }
                visible: selectId.currentIndex == 0
                font.pixelSize: Theme.fontSizeMedium
                color: "#e3decb"
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: "Ile tego zjadłeś?"
            }

            TextField
            {
                id: unitFood
                anchors {
                    left: parent.left
                    leftMargin: Theme.horizontalPageMargin
                    right: parent.right
                    rightMargin: Theme.horizontalPageMargin
                }
                visible: selectId.currentIndex == 0
                width: parent.width
                inputMethodHints: Qt.ImhDigitsOnly
                placeholderText: "200"
                color: "#f7f5f0"
                validator: IntValidator
                {
                    bottom: 1
                }
            }
            ComboBox {
                id: unitId
                Material.foreground: "#fff"
                Material.background: "#55737373"
                Material.theme: Material.Light
                visible: selectId.currentIndex == 0
                model: ["g", "ml", "sztuk"]
                anchors {
                    left: parent.left
                    leftMargin: Theme.horizontalPageMargin
                    right: parent.right
                    rightMargin: Theme.horizontalPageMargin
                }
            }

            Label
            {
                id: drug
                anchors
                {
                   left: parent.left
                   leftMargin: Theme.horizontalPageMargin
                   right: parent.right
                   rightMargin: Theme.horizontalPageMargin
                }
                visible: selectId.currentIndex == 1
                font.pixelSize: Theme.fontSizeMedium
                color: "#e3decb"
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: "Wybierz lek"
            }

            ComboBox {
                id: drugsName
                Material.foreground: "#fff"
                Material.background: "#55737373"
                Material.theme: Material.Light
                property int drugId
                visible: selectId.currentIndex == 1
                model: drugs.model
                textRole: "name"
                anchors {
                    left: parent.left
                    leftMargin: Theme.horizontalPageMargin
                    right: parent.right
                    rightMargin: Theme.horizontalPageMargin
                }
                delegate: ItemDelegate {
                    text: name
                    onClicked: {
                        drugsName.drugId = drug_id
                        drugsName.popup.close()
                    }
                }
            }


//            ComboBox
//            {
//                id: drugsName
//
//                property int drugId
//                currentIndex: 0
//                label: "Lek "
//                value: "Wybierz"
//                menu: ContextMenu
//                {
//                    Repeater
//                    {
//                        model: drugs.model
//                        MenuItem
//                        {
//                            text: name
//                            onClicked:
//                            {
//                                drugsName.drugId = id
//                                drugsName.value = text
//                            }
//                        }
//                    }
//                }
//            }

            Label
            {
                id: howMachYouDope
                anchors
                {
                   left: parent.left
                   leftMargin: Theme.horizontalPageMargin
                   right: parent.right
                   rightMargin: Theme.horizontalPageMargin
                }
                visible: selectId.currentIndex == 1
                font.pixelSize: Theme.fontSizeMedium
                color: "#e3decb"
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: "Ile go przyjąłeś"
            }

            TextField
            {
                id: unitDrugs
                anchors {
                    left: parent.left
                    leftMargin: Theme.horizontalPageMargin
                    right: parent.right
                    rightMargin: Theme.horizontalPageMargin
                }
                visible: selectId.currentIndex == 1
                width: parent.width
                inputMethodHints: Qt.ImhDigitsOnly
                validator: IntValidator
                {
                    bottom: 1
                }
                placeholderText: "6"
                color: "#f7f5f0"
            }

            ComboBox {
                id: drugsId
                Material.foreground: "#fff"
                Material.background: "#55737373"
                Material.theme: Material.Light
                visible: selectId.currentIndex == 1
                model: ["dm/L", "g", "ml", "sztuk"]
                anchors {
                    left: parent.left
                    leftMargin: Theme.horizontalPageMargin
                    right: parent.right
                    rightMargin: Theme.horizontalPageMargin
                }
            }

            Label
            {
                id: notesMemorise
                anchors
                {
                   left: parent.left
                   leftMargin: Theme.horizontalPageMargin
                   right: parent.right
                   rightMargin: Theme.horizontalPageMargin
                }
                visible: selectId.currentIndex == 2
                font.pixelSize: Theme.fontSizeMedium
                color: "#e3decb"
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: "Uwagi dotyczące pomiaru"
            }


            TextField
            {
                id: notesText
                anchors {
                    left: parent.left
                    leftMargin: Theme.horizontalPageMargin
                    right: parent.right
                    rightMargin: Theme.horizontalPageMargin
                }
                visible: selectId.currentIndex == 2
                width: parent.width
                placeholderText: "Jeździłem na rowerze przez 30 min"
                color: "#f7f5f0"
            }

        }
    }
}
