import QtQuick 2.0
import QtQuick.Controls 2.3
import QtGraphicalEffects 1.0
import glukometr 1.0
import ".."
import "../components"

DialogPage
{
    id: dialog
    property int meal;
    header: DialogHeader { id: naglowek }

    Column
    {
        width: parent.width

        Repeater
        {
            model: application.mealListModel
            delegate: ItemDelegate
            {
                Connections {
                    target: dialog
                    onMealChanged: checkIcon.visible = dialog.meal == meal
                }
                icon.name: iconSource
                text: name
                highlighted: checkIcon.visible
                width: parent.width

                IconLabel
                {
                    id: checkIcon
                    text: "\ue86c"
                    font.pixelSize: 32
                    visible: dialog.meal == meal
                    anchors
                    {
                        right: parent.right
                        rightMargin: Theme.horizontalPageMargin
                        verticalCenter: parent.verticalCenter
                    }
                }
                onClicked: { dialog.meal = meal; dialog.accept() }
            }
        }
    }
}
