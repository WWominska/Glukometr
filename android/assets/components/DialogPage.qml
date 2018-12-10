import QtQuick 2.0
import QtQuick.Controls 2.3
import glukometr 1.0
import ".."


Page {
    id: page
    background: OreoBackground {}
    signal accepted
    signal canceled
    signal done
    property bool result: false
    property bool canAccept: true
    property bool canCancel: true

    header: PageHeader {
        id: pageHeader
        title: page.title
        leftCallback: function () { cancel() }
        rightIcon: "\ue5ca"
        rightCallback: function () { accept() }
    }

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
