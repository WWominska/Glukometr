import QtQuick 2.0
import io.thp.pyotherside 1.4


Item {
    GlucoseListModel {
        id: drugsModel
        interpreter: python
        pythonClass: "glukometr.drugs"
        Component.onCompleted: get()
    }

    GlucoseListModel {
        id: thresholdsModel
        interpreter: python
        pythonClass: "glukometr.thresholds"
        Component.onCompleted: get()

        function reset() {
            return python.call(pythonClass + ".set_defaults", [],
                               function () { get(); })
        }
    }

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
        id: measurementsModel
        interpreter: python
        pythonClass: "glukometr.measurements"

        function getLastSequenceNumber(deviceId, callback) {
            python.call(pythonClass + ".get_last_sequence_number",
                [deviceId, ], callback)
        }
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
    }

    property alias measurements: measurementsModel
    property alias devices: devicesModel
    property alias drugs: drugsModel
    property alias thresholds: thresholdsModel
    property alias mealAnnotations: mealAnnotationsModel
    property alias textAnnotations: textAnnotationsModel
    property alias drugAnnotations: drugAnnotationsModel
    property alias reminders: remindersModel

    function evaluateMeasurement(value, meal) {
        return python.call_sync("glukometr.thresholds.evaluate_measurement", [
                                value, meal, ]);
    }

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
