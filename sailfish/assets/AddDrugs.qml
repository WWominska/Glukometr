import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog
{
    id: addDrugsDialog
    property alias value: nameField.text
    property bool isEdited: false

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

             DialogHeader { id: header }

             SectionHeader
             {
                font.pixelSize: Theme.fontSizeLarge
                text: isEdited ? "Zmień nazwe leku" : "Dodaj nowy lek"
                font.bold: true
             }

             TextField
             {
                 id: nameField
                 width: parent.width
                 placeholderText: "Novorapid"
                 placeholderColor: Theme.highlightBackgroundColor
                 label: isEdited ? "Nowa nazwa" : "Lek, który chcesz dodać"
             }
        }
    }
}
