import QtQuick 2.0
import io.thp.pyotherside 1.4


Item {
    GlucoseListModel {
        id: mealAnnotationsModel
        interpreter: python
        pythonClass: "glukometr.meal_annotations"
    }

    GlucoseListModel {
        id: textAnnotationsModel
        interpreter: python
        pythonClass: "glukometr.text_annotations"
    }

    GlucoseListModel {
        id: drugAnnotationsModel
        interpreter: python
        pythonClass: "glukometr.drug_annotations"
    }

    GlucoseListModel {
        id: devicesModel
        interpreter: python
        pythonClass: "glukometr.devices"

        function isKnown(macAddress, callback) {
            python.call(pythonClass + ".is_known", [macAddress, ], callback)
        }

        function getDeviceId(macAddress, callback) {
            python.call(pythonClass + ".get_by_mac", [macAddress, ], callback)
        }
    }

    GlucoseListModel {
        id: remindersModel
        interpreter: python
        pythonClass: "glukometr.reminders"

        function cancel(cookie, callback) {
            python.call(pythonClass + ".cancel", [cookie, ], callback)
        }

        function remind(title, reminder_type, when, repeating, callback) {
            python.call(pythonClass + ".remind",
                        [title, reminder_type, when, repeating, ], callback)
        }

        function remindInTwoHours() {
            var now = new Date().getTime();
            var twoHoursLater = new Date(now + (1000*60)*60*2);
            addReminder(0, twoHoursLater, 0);
        }

        function addReminder(reminder_type, when, repeating) {
            var text = "";
            switch (reminder_type) {
            case 0: text = "Zmierz cukier"; break;
            case 1: text = "Weź leki"; break;
            case 2: text = "Zjedz coś"; break;
            }
            remind(text, reminder_type, when, repeating, function () { get() });
        }
    }

    property alias devices: devicesModel
    property alias mealAnnotations: mealAnnotationsModel
    property alias textAnnotations: textAnnotationsModel
    property alias drugAnnotations: drugAnnotationsModel
    property alias reminders: remindersModel

    Python {
        id: python
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../python'));
            importModule('glukometr', function () {});
        }

        function loadListModel(pythonMethod, model, filters, callback) {
            call(pythonMethod, [filters, ], function(results) {
                model.clear()
                for (var i=0; i<results.length; i++) {
                    model.append(results[i]);
                }
                callback();
            });
        }

        onError: console.log('python error: ' + traceback);
        onReceived:  console.log('got message from python: ' + data);
    }
}
