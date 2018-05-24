import QtQuick 2.0

Item {
    ListModel { id: listModel }

    property bool reload: true
    property bool prepend: false
    property var interpreter
    property string pythonClass
    property alias model: listModel
    property var lastFilters


    function get(filters) {
        interpreter.loadListModel(pythonClass + ".get", listModel, filters);
        lastFilters = filters;
    }
    function add(object) {
        interpreter.call(pythonClass + ".add", [object, ], function (result) {
            // update model only if call didn't fail
            if (result) {
                if (!reload) {
                    if (prepend) {
                        listModel.insert(0, result);
                    } else {
                        listModel.append(result);
                    }
                } else get(lastFilters);  // reload
            }
        })
    }

    function find(object_id) {
        // find object on list model
        for (var i = 0; i < listModel.count; i++) {
            var object = listModel.get(i);
            if (object.id === object_id)
                return i;
        }
        return -1;
    }

    function update(object_id, changes, noRefresh) {
        interpreter.call(pythonClass + ".update", [object_id, changes, ],
            function (result) {
                // update only if call didn't fail
                if (result && !noRefresh) {
                    if (!reload) {
                        var index = find(object_id);
                        if (index !== -1) {
                            var listItem = listModel.get(index);
                            var keys = Object.keys(changes);
                            for (var i = 0; i < keys.length; i++) {
                                var key = keys[i];
                                listItem[key] = changes[key]
                            }
                        }
                    } else get(lastFilters);
                }
            })
    }

    function remove(object_id, index) {
        interpreter.call(pythonClass + ".delete", [object_id, ],
            function (result) {
                // remove only if call didn't fail
                if (result) {
                    if (!reload) {
                        if (!index)
                            index = find(object_id);
                        if (index !== -1)
                            listModel.remove(index);
                    } else get(lastFilters);
                }
            })
    }
}
