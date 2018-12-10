import QtQuick 2.0
import Sailfish.Silica 1.0
import "../components"

Dialog
{
    id: dialog
    property int meal;

    Column
    {
        width: parent.width
        DialogHeader { id: naglowek }

        Repeater
        {
            model: application.mealListModel
            delegate: MealComponent
            {
                selected: dialog.meal === model.modelData.meal
                onClicked: { dialog.meal = model.modelData.meal; dialog.accept() }
            }
        }
    }
}
