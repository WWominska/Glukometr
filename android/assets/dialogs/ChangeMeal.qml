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
    title: qsTr("Zmień porę")

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
                    onMealChanged: checkIcon.visible = dialog.meal === model.modelData.meal
                }
                icon.name: model.modelData.iconSource
                text: model.modelData.name
                highlighted: checkIcon.visible
                width: parent.width

                IconLabel
                {
                    id: checkIcon
                    text: "\ue86c"
                    font.pixelSize: 32
                    visible: dialog.meal === model.modelData.meal
                    anchors
                    {
                        right: parent.right
                        rightMargin: Theme.horizontalPageMargin
                        verticalCenter: parent.verticalCenter
                    }
                }
                onClicked: { dialog.meal = model.modelData.meal; dialog.accept() }
            }
        }
    }
}
