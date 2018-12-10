
import QtQuick 2.0
import Sailfish.Silica 1.0
import QtGraphicalEffects 1.0
Page
{
    id: screen

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: column.height

        PullDownMenu
        {
            MenuItem
            {
                text: qsTr("Przywróć ustawienia domyślne")
                onClicked: thresholds.setDefaults()
            }
        }

        Column
        {
            id: column
            width: screen.width
            spacing: Theme.paddingLarge

            PageHeader
            {
                title: qsTr("Ustaw progi")
            }

            ExpandingSectionGroup
            {
                currentIndex: 0
                Repeater
                {
                    model: thresholds.model

                    ExpandingSection
                    {
                        id: section

                        property int sectionIndex: index
                        title: application.mealListModel[meal].name

                        Image
                        {
                            width: Theme.iconSizeMedium
                            height: width

                            x: !expanded ? Theme.horizontalPageMargin : parent.width - width - Theme.horizontalPageMargin
                            Behavior on x
                            {
                                NumberAnimation
                                {
                                easing.type: Easing.InCubic
                                easing.amplitude: 3.0
                                easing.period: 2.0
                                duration: 250
                                }
                            }
                            anchors
                            {
                                top: parent.top
                                topMargin: (Theme.itemSizeMedium - height)/2
                            }

                            source: application.lightTheme ? application.mealListModel[meal].lightIcon : application.mealListModel[meal].icon
                        }


                        content.sourceComponent: Column
                        {
                            function updateThreshold() {
                                if (min != minScroll.value|| max != maxScroll.value) {
                                    thresholds.update({
                                        "threshold_id": threshold_id,
                                    }, {
                                        "min": minScroll.value,
                                        "max": maxScroll.value
                                    }, false)
                                }
                            }

                            width: section.width
                            Slider
                            {
                                stepSize: 5
                                id: minScroll
                                width: parent.width
                                minimumValue: 90
                                maximumValue: 180
                                value: min
                                valueText: value
                                anchors.horizontalCenter: parent.horizontalCenter
                                onDownChanged: updateThreshold()
                            }

                            Slider
                            {
                                stepSize: 5
                                id: maxScroll
                                width: parent.width
                                minimumValue: 110
                                maximumValue: 260
                                value: max
                                valueText: value
                                anchors.horizontalCenter: parent.horizontalCenter
                                onDownChanged: updateThreshold()
                            }
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: thresholds.get()
    Component.onDestruction: thresholds.get()
}

