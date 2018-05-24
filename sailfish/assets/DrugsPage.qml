import QtQuick 2.0
import Sailfish.Silica 1.0

Page
{
    id: drugs

    SilicaListView
    {
        header: PageHeader {
            id: pageHeader
            title: "Narkotyki"
        }
        PullDownMenu
        {
            MenuItem
            {
                text: "Ćpaji"
                onClicked: pythonGlukometr.drugs.add({"name": "hera koka hasz lsd"})
            }
        }
        VerticalScrollDecorator {}


        id: ksiazka
        anchors.fill: parent
        model: pythonGlukometr.drugs.model
        delegate: ListItem
        {
            id: pomiar
            contentHeight: sugar.height + Theme.paddingSmall*2
            menu: ContextMenu
            {
                MenuItem
                {
                    text: "Usuń"
                    onClicked: pythonGlukometr.drugs.remove(id, index)
                }

                MenuItem
                {
                    text: "Hehehe"
                    onClicked: pythonGlukometr.drugs.update(id, {"name": "lol"})
                }
            }

            Label
            {
                id: sugar
                font.pixelSize: Theme.fontSizeSmall
                font.bold: true
                text: name
                anchors.left: parent.left
                anchors.top: parent.top
            }
        }
    }
}
