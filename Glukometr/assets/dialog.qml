import QtQuick 2.0

Rectangle {
    id: root
    opacity: 0.8
    color: "#000000"
    anchors.horizontalCenter: parent.horizontalCenter

    property int hr: glukometr.hr
    Text {
        text: glukometr.wiadomosc
        color: "#3870BA"
    }

    onHrChanged: {
        if (glukometr.hr > 0) {
            root.destroy()
        }
    }
}
