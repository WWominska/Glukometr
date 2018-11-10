import QtQuick 2.0
import QtQuick.Controls 2.3
import ".."
import "../components"

Page
{
    id: drugsPage
    header: PageHeader
    {
        id: pageHeader
        title: "Leki"
    }
    background: OreoBackground {}

    ListView
    {

        ScrollBar.vertical: ScrollBar { }
        ToolBar {
            id: toolBar
            width: parent.width
            anchors.bottom: parent.bottom
            Row{
                anchors.fill: parent

                ToolButton {
                    width: parent.width/3
                    icon.source: "qrc:/icons/icon-m-add.svg"
                    onClicked:
                    {
                        var dialog = pageStack.push(Qt.resolvedUrl("qrc:/assets/dialogs/AddDrug.qml"))
                        dialog.accepted.connect(function()
                        {
                            drugs.add({"name": dialog.value})
                        })
                    }
                }
            }
        }

        id: drugsBook
        anchors.fill: parent
        model: drugs.model
        delegate: ListItem
        {
            id: drugItem
            //RemorseItem { id: remorseDrug }
            menu: Menu
            {
                MenuItem
                {
                    text: "Usuń"
                    onClicked: remorse.execute(drugItem, "Usunięcie leku", function() {drugs.remove(drug_id) } )
                }

                MenuItem
                {
                    text: "Edytuj"
                    onClicked:
                    {
                        var dialog = pageStack.push(Qt.resolvedUrl("qrc:/assets/dialogs/AddDrug.qml"), {
                                                        "value": name,
                                                        "isEdited": true,
                                                    })
                        dialog.accepted.connect(function()
                        {
                            drugs.update({"drug_id": drug_id}, {"name": dialog.value})
                        })
                    }
                }
            }

            Label
            {
                id: drugLabel
                font.pixelSize: Theme.fontSizeMedium
                text: name
                anchors
                {
                    left: parent.left
                    margins: Theme.horizontalPageMargin
                    verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}
