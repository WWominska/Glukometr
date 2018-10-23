import QtQuick 2.0
import QtQuick.Controls 2.3
import QtGraphicalEffects 1.0
import ".."
import "../components"

ItemDelegate {
    id: delegate
    property alias contentHeight: delegate.height
    property var menu
    width: parent.width

    onPressAndHold: {
        if (menu)
            menu.open()
    }
}
