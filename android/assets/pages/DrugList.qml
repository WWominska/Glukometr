import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.1
import ".."
import "../components"

Page
{
    id: drugsPage
    header: PageHeader
    {
        id: pageHeader
        title: qsTr("Leki")
    }
    background: OreoBackground {}

    FloatingActionButton {
        Material.foreground: "#000"
        Material.background: "#99f7f5f0"
        text: "\ue145"
        onClicked: {
            var dialog = pageStack.push(Qt.resolvedUrl("qrc:/assets/dialogs/AddDrug.qml"))
            dialog.accepted.connect(function()
            {
                drugs.add({"name": dialog.value})
            })
        }
    }

    ListView
    {

        ScrollBar.vertical: ScrollBar { }

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
                    text: qsTr("Usuń")
                    onClicked: remorse.execute(drugItem, qsTr("Usunięcie leku"), function() {drugs.remove(drug_id) } )
                }

                MenuItem
                {
                    text: qsTr("Edytuj")
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
