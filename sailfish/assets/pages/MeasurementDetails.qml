import QtQuick 2.0
import Sailfish.Silica 1.0

Page
{
    id: details
    property var measurement_id
    property date timestamp
    property int value

    SilicaFlickable
    {
        VerticalScrollDecorator  {}
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: measurementHeader.height + measurementDetails.height + mealList.height + drugsList.height + textList.height + Theme.horizontalPageMargin*3


        PullDownMenu
        {
            MenuItem
            {
                text: "Dodaj notatkę"
                onClicked: {
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
        }
        PageHeader
        {
            id: measurementHeader
            title: "Pomiar"
        }

        Rectangle
        {
            id: measurementDetails
            width: parent.width
            anchors
            {
                top: measurementHeader.bottom
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
                anchors.horizontalCenter: parent.horizontalCenter

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
                    width: Theme.iconSizeMedium
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
                   color: Theme.highlightColor
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
                   color: Theme.secondaryColor
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
                   color: Theme.secondaryColor
                   font.pixelSize: Theme.fontSizeSmall
               }

               RemorseItem { id: remorseFood }
               contentHeight: nameId.height + amountId.height + Theme.paddingSmall * 3
               menu: ContextMenu
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
                               mealAnnotations.update({"annotation_meal_id": annotation_meal_id}, {
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
                       onClicked: remorseFood.execute(foreverFood, "Usunięcie posiłku", function() {mealAnnotations.remove(annotation_meal_id) } )
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
                    width: Theme.iconSizeMedium
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
                    color: Theme.highlightColor
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
                    color: Theme.secondaryColor
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
                    color: Theme.secondaryColor
                    font.pixelSize: Theme.fontSizeSmall
                }

                RemorseItem { id: remorseDrugs }
                contentHeight: drugNameId.height + doseId.height + Theme.paddingSmall*3
                menu: ContextMenu
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
                               drugAnnotations.update({"annotation_drug_id": annotation_drug_id}, {
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
                       onClicked: remorseDrugs.execute(drugsEverywhere, "Usunięcie leku", function() {drugAnnotations.remove(annotation_drug_id) } )
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
                RemorseItem { id: remorseNotes }
               contentHeight: contentId.height + Theme.paddingSmall*3
               menu: ContextMenu
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
                               textAnnotations.update({"annotation_text_id": annotation_text_id}, {
                                   "content": dialog.textNotes
                               })
                           })
                       }
                   }
                   MenuItem
                   {
                       text: "Usuń"
                       onClicked: remorseNotes.execute(notes, "Usunięcie notatki", function() {textAnnotations.remove(annotation_text_id) } )
                   }
               }
            }
        }
    }
}
