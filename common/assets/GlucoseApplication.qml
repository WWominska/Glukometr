import QtQuick 2.0
import io.thp.pyotherside 1.4


Item {
    ListModel { id: measurementsModel }

    property alias measurements: measurementsModel

    function getLastSequenceNumber(device_id) {
        python.call("glukometr.measurements. get_last_sequence_number",
                    [device_id, ], function (result) {
                        glukometr.lastSequenceNumber = result;
                    })
    }

    function getMeasurements() {
        python.loadListModel("glukometr.measurements.get", measurementsModel);
    }

    function addMeasurement(value, timestamp, device, sequence_number, meal) {
        python.call("glukometr.measurements.add", [
                        value, timestamp, device, sequence_number, meal, ],
                    function () {
                        getMeasurements();
                        if (device) {
                            glukometr.lastSequenceNumber = sequence_number;
                        }
                    })
    }

    function deleteMeasurement(id) {
        python.call("glukometr.measurements.remove", [id, ],
                    function () { getMeasurements(); });
    }

    function updateMeasurement(id, meal) {
        python.call("glukometr.measurements.update", [id, meal, ],
                    function () { getMeasurements(); });
    }

    Connections {
        target: glukometr
        onNewMeasurement: addMeasurement(value, timestamp, device,
                                         sequence_number, undefined)
    }

    Python {
        id: python
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../python'));
            importModule('glukometr', function () {});
            getLastSequenceNumber(1);
        }

        function loadListModel(pythonMethod, model) {
            call(pythonMethod, [], function(result) {
                model.clear()
                for (var i=0; i<result.length; i++) {
                    model.append(result[i]);
                }
            });
        }

        onError: console.log('python error: ' + traceback);
        onReceived:  console.log('got message from python: ' + data);
    }
}
