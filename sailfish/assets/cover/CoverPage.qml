import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground
{
    Label
    {
        id: lastMeasurement
        anchors.centerIn: parent
        font.pixelSize: Theme.fontSizeHuge
        text: pythonGlukometr.measurements.model.get(0).value
    }


    CoverActionList
    {
        id: coverAction

        CoverAction
        {
            iconSource: "image://theme/icon-cover-new"
            onTriggered:
            {
                application.activate()
                var dialog = application.pageStack.push(Qt.resolvedUrl("../AddNewMeasurement.qml"))
                dialog.accepted.connect(function()
                {
                    pythonGlukometr.measurements.add({
                        "value": dialog.value,
                        "meal": dialog.meal
                    });
                })
            }
        }

        CoverAction
        {
            iconSource: "image://theme/icon-s-bluetooth"
            onTriggered:
            {
                application.activate()
                application.pageStack.push("../home.qml")
            }
        }
    }
}
