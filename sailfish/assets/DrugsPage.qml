import QtQuick 2.0
import Sailfish.Silica 1.0

Page
{
    id: drugs

    SilicaListView
    {
        header: PageHeader
        {
            id: pageHeader
            title: "Leki"
        }
        PullDownMenu
        {
            MenuItem
            {
                text: "Dodaj lek"
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
        VerticalScrollDecorator {}


        id: drugsBook
        anchors.fill: parent
        model: pythonGlukometr.drugs.model
        delegate: ListItem
        {
            id: drugItem
            RemorseItem { id: remorseDrug }
            contentHeight: drugLabel.height + Theme.paddingSmall*2
            menu: ContextMenu
            {
                MenuItem
                {
                    text: "Usuń"
                    onClicked: remorseDrug.execute(drugItem, "Usunięcie leku", function() {pythonGlukometr.drugs.remove(id, index) } )
                }

                MenuItem
                {
                    text: "Edytuj"
                    onClicked:
                    {
                        var dialog = pageStack.push(Qt.resolvedUrl("AddDrugs.qml"), {
                                                        "value": name,
                                                        "isEdited": true,
                                                    })
                        dialog.accepted.connect(function()
                        {
                            pythonGlukometr.drugs.update(id, {"name": dialog.value})
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
