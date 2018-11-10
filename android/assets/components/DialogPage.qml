import QtQuick 2.0
import QtQuick.Controls 2.3
import glukometr 1.0
import ".."


Page {
    background: OreoBackground {}
    signal accepted
    signal canceled
    signal done
    property bool result: false
    property bool canAccept: true
    property bool canCancel: true

    function accept() {
        if (canAccept) {
            result = true
            done()
            accepted()
        }
    }
    function cancel() {
        if (canCancel) {
            result = false
            done()
            canceled()
        }
    }

    onDone: pageStack.pop()
}
