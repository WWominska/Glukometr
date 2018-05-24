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
            return python.call("glukometr.thresholds.set_defaults", [],
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

    ListModel { id: measurementsModel }
    ListModel { id: rememberedDevicesModel }
    ListModel { id: discoveredDevicesModel }

    property alias measurements: measurementsModel
    property alias rememberedDevices: rememberedDevicesModel
    property alias discoveredDevices: discoveredDevicesModel
    property alias drugs: drugsModel
    property alias thresholds: thresholdsModel
    property alias mealAnnotations: mealAnnotationsModel
    property alias textAnnotations: textAnnotationsModel
    property alias drugAnnotations: drugAnnotationsModel

    signal gotDeviceId(string macAddress, int deviceId);
    signal gotLastSequenceNumber(int deviceId, int lastSequenceNumber);

    function getDeviceId(macAddress) {
        python.call("glukometr.devices.get_by_mac", [macAddress, ],
                    function (result) {
                        if (result !== -1) gotDeviceId(macAddress, result)
                    })
    }

    function forgetDevice(deviceId) {
        python.call("glukometr.devices.remove", [deviceId, ], function () {
            python.loadListModel("glukometr.devices.get", rememberedDevices);
            getMeasurements();
        })
    }

    function setLastUpdateDate(deviceId, timestamp) {
        python.call("glukometr.devices.update_last_sync", [deviceId, timestamp, ],
            function () {
                python.loadListModel("glukometr.devices.get", rememberedDevices);
            })
    }

    function renameDevice(deviceId, name) {
        python.call("glukometr.devices.rename", [deviceId, name, ],
            function () {
                python.loadListModel("glukometr.devices.get", rememberedDevices);
            })
    }

    function addDevice(name, mac_address, remember) {
        python.call("glukometr.devices.add", [name, mac_address, remember, ]);
    }

    function evaluateMeasurement(value, meal) {
        return python.call_sync("glukometr.thresholds.evaluate_measurement", [
                                value, meal, ]);
    }

    function getLastSequenceNumber(deviceId) {
        python.call("glukometr.measurements.get_last_sequence_number",
                    [deviceId, ], function (result) {
                        gotLastSequenceNumber(deviceId, result)
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

    Python {
        id: python
        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('../python'));
            importModule('glukometr', function () {});

            setHandler("rememberedDevicesChanged", function (devices) {
                setListModel(devices, rememberedDevices);
            })
            setHandler("discoveredDevicesChanged", function (devices) {
                setListModel(devices, discoveredDevices);
            })
            loadListModel("glukometr.devices.get", rememberedDevices);

            // test data
            addDevice("Glukometr w domu", "02:03:04:05:06", false)
            addDevice("Glukometr w chlebie", "00:00:00:00:00", false)
            addDevice("Glukometr w tortilli", "01:01:01:01:01", false)
            addDevice("Glukometr w biurze", "06:02:05:03:00", false)
        }

        function setListModel(results, model) {
            model.clear()
            for (var i=0; i<results.length; i++) {
                model.append(results[i]);
            }
        }

        function loadListModel(pythonMethod, model, filters) {
            call(pythonMethod, [filters, ], function(results) {
                setListModel(results, model);
            });
        }

        onError: console.log('python error: ' + traceback);
        onReceived:  console.log('got message from python: ' + data);
    }
}
