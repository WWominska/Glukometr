import QtQuick 2.0
import io.thp.pyotherside 1.4


Item {
    ListModel { id: measurementsModel }

    property alias measurements: measurementsModel

    function getMeasurements() {
        python.loadListModel("glukometr.measurements.get", measurementsModel);
    }

    function addMeasurement(value, timestamp, device, sequence_number, meal) {
        python.call("glukometr.measurements.add", [
                        value, timestamp, device, sequence_number, meal, ],
                    function () { getMeasurements(); })
    }

    function deleteMeasurement(id) {
        python.call("glukometr.measurements.remove", [id, ],
                    function () { getMeasurements(); });
    }

    function updateMeasurement(id, meal) {
        python.call("glukometr.measurements.update", [id, meal, ],
                    function () { getMeasurements(); });
    }

    Python {
        id: python
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../python'));
            importModule('glukometr', function () {});
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
