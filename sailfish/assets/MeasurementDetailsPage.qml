import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: details
    property var measurement_id
    property date timestamp
    property int value


    SilicaFlickable {
        anchors.fill: parent
        PageHeader { title: "Pomiar" }
        Column {
            anchors {
                left: parent.left
                right: parent.right
                margins: Theme.horizontalPageMargin
            }
            Label {
                anchors { left: parent.left; right: parent.right }
                wrapMode: Text.WordWrap
                text: "Za kazdym razem gdy dajesz innego sqla niż w modelu fizycznym bazy danych dr Laskoś zabija kotka"
            }
            Label {
                text: details.value
            }
            Button {
                text: "KEBAB"
                onClicked: pythonGlukometr.mealAnnotations.add({
                    "name": "Kebab",
                    "measurement_id": measurement_id,
                    "amount": 3,
                    "unit": "kg"
                })
            }

            Repeater {
                model: pythonGlukometr.mealAnnotations.model
                Component.onCompleted: {
                    pythonGlukometr.mealAnnotations.get({
                        "measurement_id": measurement_id
                    })
                }
                delegate: ListItem {
                   Column {
                       Label { text: name }
                       Label { text: amount }
                       Label { text: unit }
                   }
                   menu: ContextMenu
                   {
                       MenuItem
                       {
                           text: "Ulepsz kebap"
                           onClicked:
                           {
                               pythonGlukometr.mealAnnotations.update(id, {
                                "name": "Kepap f hlepie"
                               })
                           }
                       }
                       MenuItem
                       {
                           text: "Usuń"
                           onClicked: pythonGlukometr.mealAnnotations.remove(id)
                       }
                   }
                }

            }
            Button {
                text: "Koty"
                onClicked: pythonGlukometr.textAnnotations.add({
                    "content": "koty liżą masło",
                    "measurement_id": measurement_id,
                })
            }

            Repeater {
                model: pythonGlukometr.textAnnotations.model
                Component.onCompleted: {
                    pythonGlukometr.textAnnotations.get({
                        "measurement_id": measurement_id
                    })
                }
                delegate: ListItem {
                   Column {
                       Label { text: content }
                   }
                   menu: ContextMenu
                   {
                       MenuItem
                       {
                           text: "allenapewno??????????"
                           onClicked:
                           {
                               pythonGlukometr.textAnnotations.update(id, {
                                "content": "tak to prawda"
                               })
                           }
                       }
                       MenuItem
                       {
                           text: "Usuń"
                           onClicked: pythonGlukometr.textAnnotations.remove(id)
                       }
                   }
                }

            }
            Button {
                text: "dawaj w żyłę"
                onClicked: pythonGlukometr.drugAnnotations.add({
                    "drug_id": 1,
                    "dose": 5,
                    "unit": "dm/L",
                    "measurement_id": measurement_id
                })
            }

            Repeater {
                model: pythonGlukometr.drugAnnotations.model
                Component.onCompleted: {
                    pythonGlukometr.drugAnnotations.get({
                        "measurement_id": measurement_id
                    })
                }
                delegate: ListItem {
                   Column {
                       Label { text: drug_name }
                       Label { text: dose }
                       Label { text: unit }
                   }
                   menu: ContextMenu
                   {
                       MenuItem
                       {
                           text: "przerzuc sie na twarde"
                           onClicked:
                           {
                               pythonGlukometr.drugAnnotations.update(id, {
                                "drug_id": 2
                               })
                           }
                       }
                       MenuItem
                       {
                           text: "Usuń"
                           onClicked: pythonGlukometr.drugAnnotations.remove(id)
                       }
                   }
                }
            }

        }
    }
}
