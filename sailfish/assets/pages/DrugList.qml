import QtQuick 2.0
import Sailfish.Silica 1.0

Page
{
    id: drugsPage

    SilicaListView
    {
        header: PageHeader
        {
            id: pageHeader
            title: qsTr("DRUGS_TITLE")
        }
        PullDownMenu
        {
            MenuItem
            {
                text: qsTr("ADD_DRUG_LABEL")
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
        VerticalScrollDecorator {}


        id: drugsBook
        anchors.fill: parent
        model: drugs.model
        delegate: ListItem
        {
            id: drugItem
            RemorseItem { id: remorseDrug }
            menu: ContextMenu
            {
                MenuItem
                {
                    text: qsTr("REMOVE_LABEL")
                    onClicked: remorseDrug.execute(drugItem, qsTr("REMOVE_DRUG_REMORSE"), function() {drugs.remove(drug_id) } )
                }

                MenuItem
                {
                    text: qsTr("EDIT_LABEL")
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
