import QtQuick 2.0
import Sailfish.Silica 1.0

Page
{
    id: details
    property var measurement_id
    property date timestamp
    property int value

    property bool inSelectMode: false
    property var selectedDrug: []
    property var selectedMeal: []
    property var selectedText: []

    Connections {
        target: drugAnnotations
        onModelChanged: bigos();
    }
    Connections {
        target: textAnnotations
        onModelChanged: bigos();
    }
    Connections {
        target: mealAnnotations
        onModelChanged: bigos();
    }

    function bigos() {
        if (textAnnotations.model.rowCount() === 0 &&
            mealAnnotations.model.rowCount() === 0 &&
            drugAnnotations.model.rowCount() === 0) {
            inSelectMode = false;
        }
    }

    SilicaFlickable
    {
        VerticalScrollDecorator  {}
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: measurementHeader.height + measurementDetails.height + mealList.height + drugsList.height + textList.height + Theme.horizontalPageMargin*3


        PullDownMenu
        {
            MenuItem {
                text: qsTr("MEASUREMENT_DETAILS_SELECT_ANNOTATIONS")
                visible: !inSelectMode
                onClicked: {
                    selectedText = [];
                    selectedMeal = [];
                    selectedDrug = [];
                    inSelectMode = true;
                }
            }

            MenuItem
            {
                text: qsTr("MEASUREMENT_DETAILS_ADD_ANNOTATION")
                visible: !inSelectMode
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

            MenuItem {
                visible: inSelectMode
                text: qsTr("REMOVE_ALL_LABEL")
                onClicked: {
                    drugAnnotations.remove({"measurement_id": measurement_id}, true)
                    textAnnotations.remove({"measurement_id": measurement_id}, true)
                    mealAnnotations.remove({"measurement_id": measurement_id}, true)
                }
            }

            MenuItem {
                visible: inSelectMode
                text: qsTr("REMOVE_SELECTED_LABEL")
                onClicked: {
                    selectedMeal.map(
                        function (id) {
                            mealAnnotations.remove(id, false)
                        }
                    )
                    selectedDrug.map(
                        function (id) {
                            drugAnnotations.remove(id, false)
                        }
                    )
                    selectedText.map(
                        function (id) {
                            textAnnotations.remove(id, false)
                        }
                    )
                    drugAnnotations.get()
                    textAnnotations.get()
                    mealAnnotations.get()
                }
            }

            MenuItem {
                visible: inSelectMode
                text: qsTr("QUIT_SELECTION_MODE_LABEL")
                onClicked: {
                    selectedText = [];
                    selectedMeal = [];
                    selectedDrug = [];
                    inSelectMode = false;
                }
            }
        }
        PageHeader
        {
            id: measurementHeader
            title: qsTr("MEASUREMENT_DETAILS_TITLE")
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

                Switch {
                    id: listItemCheckbox
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }
                    Connections {

                        target: details
                        onInSelectModeChanged: {
                            listItemCheckbox.checked = false
                        }
                    }

                    onCheckedChanged: {
                        if (checked) {
                            if (selectedMeal.indexOf(annotation_meal_id) == -1)
                                selectedMeal.push(annotation_meal_id)
                        } else {
                            selectedMeal = selectedMeal.filter(function (id) { return id !== annotation_meal_id; });
                        }
                    }

                    visible: inSelectMode
                }

                Image
                {
                    id: foodIcon
                    source: "qrc:/icons/icon-annotations-meal" + (application.lightTheme ? "-light" : "") + ".svg"
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
                       right: listItemCheckbox.visible ? listItemCheckbox.left : parent.right
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
                       right: listItemCheckbox.visible ? listItemCheckbox.left : parent.right
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
                   MenuItem {
                       text: qsTr("SELECT_LABEL")
                       onClicked: {
                           if (!inSelectMode) {
                               selectedText = [];
                               selectedDrug = [];
                               selectedMeal = [];
                               inSelectMode = true;
                           }
                           listItemCheckbox.checked = true;
                       }
                   }
                   MenuItem
                   {
                       text: qsTr("EDIT_LABEL")
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
                       text: qsTr("REMOVE_LABEL")
                       onClicked: remorseFood.execute(foreverFood, qsTr("REMOVE_MEAL_REMORSE"), function() {mealAnnotations.remove(annotation_meal_id) } )
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

                Switch {
                    id: drugListItemCheckbox
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }
                    Connections {

                        target: details
                        onInSelectModeChanged: {
                            drugListItemCheckbox.checked = false
                        }
                    }

                    onCheckedChanged: {
                        if (checked) {
                            if (selectedDrug.indexOf(annotation_drug_id) == -1)
                                selectedDrug.push(annotation_drug_id)
                        } else {
                            selectedDrug = selectedDrug.filter(function (id) { return id !== annotation_drug_id; });
                        }
                    }

                    visible: inSelectMode
                }

                Image
                {
                    id: drugsIcon
                    source: "qrc:/icons/icon-annotations-drug" + (application.lightTheme ? "-light" : "") + ".svg"
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
                        right: drugListItemCheckbox.visible ? drugListItemCheckbox.left : parent.right
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
                        right: drugListItemCheckbox.visible ? drugListItemCheckbox.left : parent.right
                        leftMargin: Theme.paddingSmall
                    }
                    color: Theme.secondaryColor
                    font.pixelSize: Theme.fontSizeSmall
                }

                RemorseItem { id: remorseDrugs }
                contentHeight: drugNameId.height + doseId.height + Theme.paddingSmall*3
                menu: ContextMenu
                {
                    MenuItem {
                        text: qsTr("SELECT_LABEL")
                        onClicked: {
                            if (!inSelectMode) {
                                selectedText = [];
                                selectedDrug = [];
                                selectedMeal = [];
                                inSelectMode = true;
                            }
                            drugListItemCheckbox.checked = true;
                        }
                    }
                    MenuItem
                    {
                       text: qsTr("EDIT_LABEL")
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
                       text: qsTr("REMOVE_LABEL")
                       onClicked: remorseDrugs.execute(drugsEverywhere, qsTr("REMOVE_DRUG_REMORSE"), function() {drugAnnotations.remove(annotation_drug_id) } )
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

                Switch {
                    id: textListItemCheckbox
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                    }
                    Connections {

                        target: details
                        onInSelectModeChanged: {
                            textListItemCheckbox.checked = false
                        }
                    }

                    onCheckedChanged: {
                        if (checked) {
                            if (selectedText.indexOf(annotation_text_id) == -1)
                                selectedText.push(annotation_text_id)
                        } else {
                            selectedText = selectedText.filter(function (id) { return id !== annotation_text_id; });
                        }
                    }

                    visible: inSelectMode
                }

                Label
                {
                    id:contentId
                    text: content
                    anchors
                    {
                        left: parent.left
                        right: textListItemCheckbox.visible ? textListItemCheckbox.left : parent.right
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
                   MenuItem {
                       text: qsTr("SELECT_LABEL")
                       onClicked: {
                           if (!inSelectMode) {
                               selectedText = [];
                               selectedDrug = [];
                               selectedMeal = [];
                               inSelectMode = true;
                           }
                           textListItemCheckbox.checked = true;
                       }
                   }
                   MenuItem
                   {
                       text: qsTr("EDIT_LABEL")
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
                       text: qsTr("REMOVE_LABEL")
                       onClicked: remorseNotes.execute(notes, qsTr("TEXT_ANNOTATION_REMORSE"), function() {textAnnotations.remove(annotation_text_id) } )
                   }
               }
            }
        }
    }
}
