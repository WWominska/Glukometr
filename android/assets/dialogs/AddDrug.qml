import QtQuick 2.0
import QtQuick.Controls 2.3
import ".."
import "../components"

DialogPage
{
    id: addDrugsDialog
    property alias value: nameField.text
    property bool isEdited: false

    header: DialogHeader {
        id: naglowek
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
            spacing: Theme.paddingSmall

             SectionHeader
             {
                font.pixelSize: Theme.fontSizeLarge
                text: isEdited ? "Zmień nazwe leku" : "Dodaj nowy lek"
             }

             TextField
             {
                 id: nameField
                 width: parent.width
                 placeholderText: "Novorapid"
                 //placeholderColor: Theme.highlightBackgroundColor
                 //label: isEdited ? "Nowa nazwa" : "Lek, który chcesz dodać"
             }
        }
    }
}
