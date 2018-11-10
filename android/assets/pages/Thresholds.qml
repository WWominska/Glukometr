import QtQuick 2.0
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.3
import ".."
import "../components"
Page
{
    id: screen

    header: PageHeader { title: "Progi" }

    Flickable
    {
        anchors.fill: parent
        contentHeight: column.height

        Column
        {
            id: column
            width: screen.width
            spacing: Theme.paddingLarge

            Button {
                text: "Przywróć ustawienia domyślne"
                onClicked: thresholds.setDefaults()
            }

            Repeater
            {
                model: thresholds.model

                Rectangle
                {
                    color: "transparent"
                    width: parent.width
                    height: contentColumn.childrenRect.height
                    id: section

                    property int sectionIndex: index


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
                            case 3: return "qrc:/icons/icon-m-night.svg"
                        }
                    }

                    Column
                    {
                        Rectangle {
                            id: sectionTitle
                            height: 48
                            color: "#33000000"
                            width: parent.width
                            Image
                            {
                                id: sectionIcon
                                width: 32
                                height: 32
                                anchors
                                {
                                    verticalCenter: parent.verticalCenter
                                }
                                source: changeToIcon(meal)
                            }
                            Label {
                                anchors {
                                    left: sectionIcon.right
                                    leftMargin: Theme.paddingLarge
                                    verticalCenter: parent.verticalCenter
                                }
                                text: changeToString(meal)
                            }
                        }

                        id: contentColumn
                        function updateThreshold() {
                            if (min != scroll.first.value || max != scroll.second.value) {
                                thresholds.update({
                                    "threshold_id": threshold_id,
                                }, {
                                    "min": scroll.first.value.toFixed(0),
                                    "max": scroll.second.value.toFixed(0)
                                }, false)
                            }
                        }

                        width: section.width
                        RangeSlider
                        {
                            stepSize: 5
                            id: scroll
                            width: parent.width
                            from: 90
                            to: 180
                            first {
                                value: min
                                onPressedChanged: parent.updateThreshold()
                            }
                            ToolTip {
                                parent: scroll.first.handle
                                visible: scroll.first.pressed
                                text: scroll.first.value.toFixed(1)
                            }
                            second {
                                value: max
                                onPressedChanged: parent.updateThreshold()
                            }
                            ToolTip {
                                parent: scroll.second.handle
                                visible: scroll.second.pressed
                                text: scroll.second.value.toFixed(0)
                            }
                            live: true
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: thresholds.get()
    Component.onDestruction: thresholds.get()
}

