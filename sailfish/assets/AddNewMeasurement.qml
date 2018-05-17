import QtQuick 2.0
import Sailfish.Silica 1.0
import QtGraphicalEffects 1.0


Dialog
{
    id: dialog
    property int meal;
    property real value;

    onDone:
    {
        if (result == DialogResult.Accepted)
        {
            value = nameField.text
        }
    }

    SilicaFlickable
    {
        VerticalScrollDecorator {}
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: column.childrenRect.height

        Column
        {
            id: column
            width: parent.width
            spacing: Theme.paddingSmall

             DialogHeader { id: naglowek }

             SectionHeader
             {
                font.pixelSize: Theme.fontSizeLarge
                text: "Podaj cukier"
                font.bold: true
             }

             TextField
             {
                 id: nameField
                 width: parent.width
                 placeholderText: "120..."
                 label: "Wartość cukru"
             }

             SectionHeader
             {
                font.pixelSize: Theme.fontSizeLarge
                text: "Pora posiłku"
                font.bold: true
             }

             Label
             {
                anchors
                {
                    left: parent.left
                    margins: Theme.horizontalPageMargin
                    right: parent.right
                }
                text: "Poniżej możesz ustawić pore w jakiej dokonałeś pomiaru"
                wrapMode: Text.WordWrap
                color: Theme.secondaryHighlightColor
                font.bold: true

             }

             Repeater
             {
                 model: ListModel
                 {
                     ListElement
                     {
                         meal: 0
                         icon: "qrc:/icons/icon-fasting.svg"
                         name: "Na czczo"
                     }

                     ListElement
                     {
                         meal: 1
                         icon: "qrc:/icons/icon-before-meal.svg"
                         name: "Przed posiłkiem"
                     }

                     ListElement
                     {
                         meal: 2
                         icon: "qrc:/icons/icon-after-meal.svg"
                         name: "Po posiłku"
                     }

                     ListElement
                     {
                         meal: 3
                         icon: "image://Theme/icon-m-night"
                         name: "Nocna"
                     }

                     ListElement
                     {
                         meal: 4
                         icon: "image://Theme/icon-m-question"
                         name: "Nie określono"
                     }
                 }
                 delegate: ListItem
                 {
                     Image
                     {
                         id: mealIcon
                         source: icon
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

                     ColorOverlay
                     {
                          anchors.fill: mealIcon
                          source: mealIcon
                          color: "#ffffff"
                     }

                     Image
                     {
                         id: checkIcon
                         source: "image://Theme/icon-m-acknowledge"
                         visible: dialog.meal == meal
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
                         color: "#ffffff"
                         text: name
                     }
                     onClicked: { dialog.meal = meal; }
                 }
             }

//             Rectangle
//             {
//                 color: "transparent"
//                 width: parent.width
//                 height: 200
//             }

             SectionHeader
             {
                font.pixelSize: Theme.fontSizeLarge
                text: "Notatka"
                font.bold: true
             }

             Label
             {
                 anchors
                 {
                     left: parent.left
                     leftMargin: Theme.horizontalPageMargin
                     right: parent.right
                     rightMargin: Theme.horizontalPageMargin
                 }
                 text: "Tu możesz wpisać własną notatkę (np. co zjadłeś, jakie ćwiczenia zrobiłeś itp...)"
                 font.pixelSize: Theme.fontSizeSmall
                 wrapMode: Text.WordWrap
                 color: Theme.secondaryHighlightColor
                 font.bold: true
             }
        }
    }
}
