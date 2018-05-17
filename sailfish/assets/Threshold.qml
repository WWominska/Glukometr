import QtQuick 2.0
import Sailfish.Silica 1.0
import QtGraphicalEffects 1.0
Page
{
    id: screen

    Component.onCompleted: pythonGlukometr.getThresholds()

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: column.height

        Column
        {
            id: column
            width: screen.width
            spacing: Theme.paddingLarge

            PageHeader
            {
                title: "Ustaw progi"
            }

            ExpandingSectionGroup
            {
                currentIndex: 0
                Repeater
                {
                    model: pythonGlukometr.thresholds

                    ExpandingSection
                    {
                        id: section

                        property int sectionIndex: model.index
                        title: changeToString(meal)

                        Image {
                            width: Theme.iconSizeMedium
                            height: width
                            x: !expanded ? Theme.horizontalPageMargin : parent.width - width - Theme.horizontalPageMargin
                            anchors {
                                top: parent.top
                                topMargin: (Theme.itemSizeMedium - height)/2
                            }

                            source: changeToIcon(meal)
                        }

                        function changeToString(meal)
                        {
                            switch(meal)
                            {
                                case 0: return "Na czczo"
                                case 1: return "Przed posiłkiem"
                                case 2: return "Po posiłku"
                                case 3: return "Nocna"
                            }
                        }

                        function changeToIcon(meal)
                        {
                            switch(meal)
                            {
                                case 0: return "qrc:/icons/icon-fasting.svg"
                                case 1: return "qrc:/icons/icon-before-meal.svg"
                                case 2: return "qrc:/icons/icon-after-meal.svg"
                                case 3: return "image://Theme/icon-m-night"
                            }
                        }

                        content.sourceComponent: Column
                        {
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
                                anchors.horizontalCenter: horizontalCenter
                                onValueChanged: pythonGlukometr.updateThreshold(meal, minScroll.sliderValue, maxScroll.sliderValue)
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
                                anchors.horizontalCenter: horizontalCenter
                                onValueChanged: pythonGlukometr.updateThreshold(meal, minScroll.value, maxScroll.value)
                            }
                        }
                    }
                }
            }
        }
    }
}

//pythonGlukometr.updateThreshold(meal, min, max)

