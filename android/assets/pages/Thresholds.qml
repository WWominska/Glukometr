import QtQuick 2.0
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3
import QtQuick.Layouts 1.3

import ".."
import "../components"

Page
{
    id: screen

    header: PageHeader { title: qsTr("Progi") }
    background: OreoBackground {}

    Flickable
    {
        anchors.fill: parent
        contentHeight: column.height

        Column
        {
            id: column
            width: screen.width
            spacing: Theme.paddingLarge
            anchors
            {
                left: parent.left
                right: parent.right
                margins: Theme.horizontalPageMargin
            }

            Button {
                text: qsTr("Przywróć ustawienia domyślne")
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
                            case 0: return qsTr("Na czczo")
                            case 1: return qsTr("Przed posiłkiem")
                            case 2: return qsTr("Po posiłku")
                            case 3: return qsTr("Nocna")
                        }
                    }

                    function changeToIcon(meal)
                    {
                        switch(meal)
                        {
                            case 0: return "fasting"
                            case 1: return "apple"
                            case 2: return "after-meal"
                            case 3: return "night"
                        }
                    }

                    Column
                    {
                        Rectangle {
                            id: sectionTitle
                            height: 48
                            color: "#33f7f5f0"
                            width: parent.width
                            ToolButton {
                                id: sectionIcon
                                icon.name: changeToIcon(meal)
                            }
                            Label {
                                anchors {
                                    left: sectionIcon.right
                                    leftMargin: Theme.paddingLarge
                                    verticalCenter: parent.verticalCenter
                                }
                                color: "#f7f5f0"
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
                        RowLayout {
                            width: parent.width
                            spacing: Theme.paddingLarge
                            Label {
                                text: "90"
                            }

                            RangeSlider
                            {
                                Layout.fillWidth: true
                                stepSize: 5
                                id: scroll
                                from: 90
                                to: 180

                                Material.accent: Material.Red

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
                            Label {
                                text: "180"
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

