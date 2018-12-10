import QtQuick 2.0
import QtQuick.Controls 2.3
import QtQuick.Controls.Material 2.3


RoundButton {
    Material.elevation: 6
    z: 3
    font.pixelSize: 40
    font.family: "Material Icons"
    width: 64
    height: 64
    anchors
    {
        right: parent.right
        rightMargin: 16
        bottom: parent.bottom
        bottomMargin: 16
    }


}
