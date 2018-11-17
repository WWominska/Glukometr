import QtQuick 2.0
import QtQuick.Controls 2.3
import ".."
import "../components"

DialogPage
{
    id: addDrugsDialog
    property alias value: nameField.text
    property bool isEdited: false

    footer: DialogHeader {}
    header: PageHeader {
        id: pageHeader
        title: isEdited ? qsTr("Zmień nazwe") : qsTr("Dodaj lek")
    }

    Flickable
    {
        ScrollBar.vertical: ScrollBar { }
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: column.childrenRect.height

//        Column
//        {
//            id: column
//            width: parent.width
//            spacing: Theme.paddingSmall


             TextField
             {
                 id: nameField
                 width: parent.width
                 placeholderText: "Novorapid"
                 anchors
                 {
                     left: parent.left
                     right: parent.right
                     top: parent.top
                     margins: Theme.horizontalPageMargin

                 }
                 //placeholderColor: Theme.highlightBackgroundColor
                 //label: isEdited ? "Nowa nazwa" : "Lek, który chcesz dodać"
             }
//        }
    }
}
