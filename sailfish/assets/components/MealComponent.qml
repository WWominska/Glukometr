import QtQuick 2.0
import Sailfish.Silica 1.0
import QtGraphicalEffects 1.0

ListItem
{
    id: mealComponent
    property bool selected;
    enabled: opacity === 1
    opacity: showIfPhase(1) ? 1.0 : disabledOpacity
    Image
    {
        id: mealIcon
        source: application.lightTheme ? model.modelData.lightIcon : model.modelData.icon
        width: Theme.iconSizeMedium
        height: width
        anchors
        {
            left: parent.left
            leftMargin: Theme.horizontalPageMargin
            top: parent.top
            topMargin: Theme.paddingSmall
        }
    }


    Image
    {
        id: checkIcon
        source: "image://Theme/icon-m-acknowledge"
        visible: mealComponent.selected
        width: Theme.iconSizeMedium
        height: width
        anchors
        {
            right: parent.right
            rightMargin: Theme.horizontalPageMargin
            top: parent.top
            topMargin: Theme.paddingSmall
        }
    }

    ColorOverlay
    {
         anchors.fill: checkIcon
         source: checkIcon
         visible: checkIcon.visible
         color: Theme.highlightColor
    }

    Label
    {
        anchors
        {
           left: mealIcon.right
           verticalCenter: parent.verticalCenter
           leftMargin: Theme.paddingMedium
        }
        font.pixelSize: Theme.fontSizeMedium
        text: model.modelData.name
    }
}
