import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    Component.onCompleted: pythonGlukometr.reminders.get()

    function makeReminder(text, reminder_type, when, repeating) {
        pythonGlukometr.reminders.remind(text, reminder_type, when, repeating,
                                         function () { pythonGlukometr.reminders.get() })
    }

    function reminderTypeToString(type) {
        switch (type) {
        case 0: return "Przypomnienie o kaszl kaszl kaszl";
        case 1: return "Pamiętaj o jedzeniu [*]";
        case 2: return "Przypomnienie o pomiarze";
        }
    }

    SilicaListView {
        anchors.fill: parent
        PullDownMenu {
            MenuItem {
                text: "Codziennie niskie ceny"
                onClicked: {
                    var now = new Date().getTime();
                    var minuteLater = new Date(now + (1000*60))  // 1000*60 bo 60 sekund (1000ms)
                    makeReminder("Będę kaszlł", 0, minuteLater, 1)
                }
            }

            MenuItem {
                text: "Kaszl kaszl kaszl"
                onClicked: {
                    var now = new Date().getTime();
                    var minuteLater = new Date(now + (1000*60))  // 1000*60 bo 60 sekund (1000ms)
                    makeReminder("Będę kaszlł", 0, minuteLater, 0)
                }
            }
            MenuItem {
                text: "Memento jedzenie"
                onClicked: {
                    var now = new Date().getTime();
                    var twoMinutesLater = new Date(now + (1000*60)*2)
                    makeReminder("Jedzenie jedzenie jedzenie", 1, twoMinutesLater, 0)
                }
            }
            MenuItem {
                text: "zrup pomjar"
                onClicked: {
                    var now = new Date().getTime();
                    var twoHoursLater = new Date(now + (1000*60*60)*2)
                    makeReminder("Zmierz się", 2, twoHoursLater, 0)
                }
            }

        }

        model: pythonGlukometr.reminders.model
        header: PageHeader { title: "Nie pamiętam co tu dać" }
        delegate: ListItem {
            contentHeight: column.childrenRect.height + 2*Theme.paddingSmall
            menu: ContextMenu {
                MenuItem {
                    text: "Usuń bro"
                    onClicked: pythonGlukometr.reminders.cancel(cookie, function () {
                        pythonGlukometr.reminders.remove(id)
                    })
                }
            }

            Column {
                id: column
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    margins: Theme.horizontalPageMargin
                    right: parent.right
                }

                Label {
                    text: new Date(timestamp*1000).toLocaleString(Qt.locale("pl_PL"),"dd.MM.yy    HH:mm")
                }
                Label {
                    text: reminderTypeToString(reminder_type)
                }
            }
        }
    }
}
