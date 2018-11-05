import QtQuick 2.0
import io.thp.pyotherside 1.4


Item {
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

    property alias devices: devicesModel

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
