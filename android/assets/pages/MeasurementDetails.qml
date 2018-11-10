import QtQuick 2.0
import QtQuick.Controls 2.3
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.3
import ".."
import "../components"

Page
{
    id: details
    property var measurement_id
    property date timestamp
    property int value

    FloatingActionButton {
       Material.foreground: "#000"
       Material.background: "#99f7f5f0"
       text: "\ue145"
       onClicked:
       {
          var dialog = pageStack.push(Qt.resolvedUrl("qrc:/assets/dialogs/AddAnnotation.qml"))
          dialog.accepted.connect(function()
          {
              switch (dialog.noteType) {
              case 0: // dodajemy posilek
                  mealAnnotations.add({
                      "name": dialog.foodName,
                      "measurement_id": measurement_id,
                      "amount": dialog.foodAmount,
                      "unit": dialog.foodUnit
                  })
                  break;
              case 1: // dodajemy lek
                  drugAnnotations.add({
                        "drug_id": dialog.drugId,
                        "dose": dialog.drugsUnit,
                        "unit": dialog.idDrugs,
                        "measurement_id": measurement_id
                    })
                  break;
              case 2: // dodajemy tegzt
                  textAnnotations.add({
                      "content": dialog.textNotes,
                      "measurement_id": measurement_id,
                  })
                  break;
              }
          })
      }
   }

    header: PageHeader {
        id: pageHeader
        title: "Szczegóły pomiaru"
    }
    background: OreoBackground {}

    Flickable
    {
        ScrollBar.vertical: ScrollBar { }
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: pageHeader.height + measurementDetails.height + mealList.height + drugsList.height + textList.height + Theme.horizontalPageMargin*3

        Rectangle
        {
            id: measurementDetails
            width: parent.width
            anchors
            {
                left: parent.left
                right: parent.right
                leftMargin: Theme.horizontalPageMargin
                rightMargin: Theme.horizontalPageMargin
            }
            height: masurementVslue.paintedHeight + Theme.paddingMedium*2
            color: "transparent"


            Label
            {
                id: masurementVslue
                anchors
                {
                    top: parent.top
                    topMargin: Theme.paddingMedium
                    horizontalCenter: parent.horizontalCenter
                }
                color: "#d9d2b9"

                text: value + " [dm/L]"
                font.pixelSize: Theme.fontSizeLarge
            }
        }

        ListView
        {
            id: mealList
            interactive: false
            anchors
            {
                top: measurementDetails.bottom
            }

            model: mealAnnotations.model
            height: contentHeight
            width: parent.width
            Component.onCompleted:
            {
                mealAnnotations.get({
                    "measurement_id": measurement_id
                })
            }
            delegate: ListItem
            {
                width: parent.width
                id: foreverFood

                Image
                {
                    id: foodIcon
                    source: "qrc:/icons/icon-annotations-meal.svg"
                    anchors
                    {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        leftMargin: Theme.horizontalPageMargin
                    }
                    width: 32
                    height: width
                }
                Label
               {
                   id:nameId
                   text: name
                   anchors
                   {
                       left: foodIcon.right
                       top: parent.top
                       topMargin: Theme.paddingSmall
                       leftMargin: Theme.paddingMedium
                   }
                   color: "#f7f5f0"
                   font.pixelSize: Theme.fontSizeMedium
               }

               Label
               {
                   id:amountId
                   text: amount
                   anchors
                   {
                       left: foodIcon.right
                       top: nameId.bottom
                       leftMargin: Theme.paddingMedium
                   }
                   color: "#d9d2b9"
                   font.pixelSize: Theme.fontSizeSmall
               }

               Label
               {
                   id: unitId
                   text: unit
                   anchors
                   {
                       top: amountId.top
                       left: amountId.right
                       leftMargin: Theme.paddingSmall
                   }
                   color: "#d9d2b9"
                   font.pixelSize: Theme.fontSizeSmall
               }

               //RemorseItem { id: remorseFood }
               contentHeight: nameId.height + amountId.height + Theme.paddingSmall * 3

               menu: Menu
               {
                   MenuItem
                   {
                       text: "Edytuj"
                       onClicked:
                       {
                           var dialog = pageStack.push(Qt.resolvedUrl("qrc:/assets/dialogs/AddAnnotation.qml"), {
                               "isEdited": true,
                               "noteType": 0,
                               "foodName": name,
                               "foodAmount": amount,
                               "foodUnit": unit
                           })
                           dialog.accepted.connect(function()
                           {
                               mealAnnotations.update(annotation_meal_id, {
                                   "name": dialog.foodName,
                                   "amount": dialog.foodAmount,
                                   "unit": dialog.foodUnit
                               })
                           })
                       }
                   }

                   MenuItem
                   {
                       text: "Usuń"
                       onClicked: remorse/*Food*/.execute(foreverFood, "Usunięcie posiłku", function() {mealAnnotations.remove(annotation_meal_id) } )
                   }
               }
            }
        }

        ListView
        {
            id: drugsList
            anchors
            {
                top: mealList.bottom
            }
            model: drugAnnotations.model
            height: contentHeight
            width: parent.width
            interactive: false
            Component.onCompleted:
            {
                drugAnnotations.get({
                    "measurement_id": measurement_id
                })
            }

            delegate: ListItem
            {
                id: drugsEverywhere

                Image
                {
                    id: drugsIcon
                    source: "qrc:/icons/icon-annotations-drug.svg"
                    anchors
                    {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        leftMargin: Theme.horizontalPageMargin
                    }
                    width: 32
                    height: width
                }

                Label
                {
                    id: drugNameId
                    text: name
                    anchors
                    {
                        left: drugsIcon.right
                        top: parent.top
                        topMargin: Theme.paddingSmall
                        leftMargin: Theme.paddingMedium
                    }
                    font.pixelSize: Theme.fontSizeMedium

                }
                Label
                {
                    id: doseId
                    text: dose
                    anchors
                    {
                        left: drugsIcon.right
                        top: drugNameId.bottom
                        leftMargin: Theme.paddingMedium
                    }
                    font.pixelSize: Theme.fontSizeSmall
                }
                Label
                {
                    id: unitId2
                    text: unit
                    anchors
                    {
                        top: doseId.top
                        left: doseId.right
                        leftMargin: Theme.paddingSmall
                    }
                    font.pixelSize: Theme.fontSizeSmall
                }

                //RemorseItem { id: remorseDrugs }
                contentHeight: drugNameId.height + doseId.height + Theme.paddingSmall*3
                menu: Menu
                {
                    MenuItem
                    {
                       text: "Edytuj"
                       onClicked:
                       {
                           var dialog = pageStack.push(Qt.resolvedUrl("qrc:/assets/dialogs/AddAnnotation.qml"), {
                               "isEdited": true,
                               "noteType": 1,
                               "drugId": drug_id,
                               "drugName": name,
                               "drugsUnit": dose,
                               "idDrugs": unit
                           })
                           dialog.accepted.connect(function()
                           {
                               drugAnnotations.update(annotation_drug_id, {
                                   "drug_id": dialog.drugId,
                                   "dose": dialog.drugsUnit,
                                   "unit": dialog.idDrugs
                               })
                           })
                       }
                   }

                   MenuItem
                   {
                       text: "Usuń"
                       onClicked: remorse/*Drugs*/.execute(drugsEverywhere, "Usunięcie leku", function() {drugAnnotations.remove(annotation_drug_id) } )
                   }
             }
            }
        }


        ListView
        {
            id: textList
            anchors
            {
                top: drugsList.bottom
            }

            model: textAnnotations.model
            height: contentHeight
            interactive: false
            width: parent.width
            Component.onCompleted:
            {
                textAnnotations.get({
                    "measurement_id": measurement_id
                })
            }

            delegate: ListItem
            {
                id: notes
                Label
                {
                    id:contentId
                    text: content
                    anchors
                    {
                        left: parent.left
                        top: parent.top
                        topMargin: Theme.paddingSmall
                        leftMargin: Theme.horizontalPageMargin
                    }
                    font.pixelSize: Theme.fontSizeMedium
                }
                //RemorseItem { id: remorseNotes }
               contentHeight: contentId.height + Theme.paddingSmall*3
               menu: Menu
               {
                   MenuItem
                   {
                       text: "Edytuj"
                       onClicked:
                       {
                           var dialog = pageStack.push(Qt.resolvedUrl("qrc:/assets/dialogs/AddAnnotation.qml"), {
                               "isEdited": true,
                               "noteType": 2,
                               "textNotes": content
                           })
                           dialog.accepted.connect(function()
                           {
                               textAnnotations.update(annotation_text_id, {
                                   "content": dialog.textNotes
                               })
                           })
                       }
                   }
                   MenuItem
                   {
                       text: "Usuń"
                       onClicked: remorse/*Notes*/.execute(notes, "Usunięcie notatki", function() {textAnnotations.remove(annotation_text_id) } )
                   }
               }
            }
        }
    }

}
