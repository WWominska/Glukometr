import QtQuick 2.0
import Sailfish.Silica 1.0

Page
{
    Component.onCompleted: pythonGlukometr.reminders.get()

    function makeReminder(text, reminder_type, when, repeating)
    {
        pythonGlukometr.reminders.remind(text, reminder_type, when, repeating,
                                         function () { pythonGlukometr.reminders.get() })
    }

    function reminderTypeToString(type)
    {
        switch (type)
        {
        case 0: return "Przypomnienie za 2h";
        case 1: return "Przypomnienie o 22";
        case 2: return "Przypomnienie o 3 w nocy";
        }
    }

    SilicaListView
    {
        anchors.fill: parent
        PullDownMenu
        {

            MenuItem
            {
                text: "Przypomnienie za 2h"
                onClicked:
                {
                    var now = new Date().getTime();
                    var minuteLater = new Date(now + (1000*7200))
                    makeReminder("Zmierz cukier!", 0, minuteLater, 0)
                }
            }

            MenuItem
            {
                text: "Przypomnienie o 22"
                onClicked:
                {
                    var now = new Date().getTime();
                    var minuteLater = new Date(now + (1000*60))  // 1000*60 bo 60 sekund (1000ms)
                    makeReminder("Zaraz 22 zmierz cukier!", 1, minuteLater, 1)
                }
            }
            MenuItem
            {
                text: "Przypomnienie o 3 w nocy"
                onClicked:
                {
                    var now = new Date().getTime();
                    var twoMinutesLater = new Date(now + (1000*60)*2)
                    makeReminder("Zaraz 3 zmierz cukier!", 2, twoMinutesLater, 1)
                }
            }
            MenuItem
            {
                text: "Dodaj przypomnienie"
                onClicked: {
                    var dialog = pageStack.push(Qt.resolvedUrl("qrc:/assets/dialogs/AddReminder.qml"))
                    dialog.accepted.connect(function()
                    {
                        var date = new Date();
                        if (date.getHours() > dialog.selectedHour) {
                            date.setDate(date.getDate() + 1); // hcemy jurto
                        }
                        date.setHours(dialog.selectedHour)
                        date.setMinutes(dialog.selectedMinute)
                        pythonGlukometr.reminders.addReminder(dialog.reminderType, date, dialog.repeating)
                    })
                }
            }
        }

        model: pythonGlukometr.reminders.model
        header: PageHeader { title: "Przypomnienia" }
        delegate: ListItem
        {
            id:list
            RemorseItem { id: remorse }
            //contentHeight: column.childrenRect.height + 2*Theme.paddingSmall
            menu: ContextMenu
            {
                MenuItem
                {
                    text: "Usuń"
                    onClicked: remorse.execute(list, "Usunięcie powiadomienia", function()
                    {
                        pythonGlukometr.reminders.cancel(cookie, function ()
                        {
                            pythonGlukometr.reminders.remove(id)
                        })
                    })
                }
            }
            Label
            {
                id:remind
                text: reminderTypeToString(reminder_type)
                anchors
                {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: Theme.horizontalPageMargin
                }
            }
            Label
            {
                id:whenCall
                text: new Date(timestamp*1000).toLocaleString(Qt.locale("pl_PL"),"HH:mm")
                anchors
                {
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                    rightMargin: Theme.horizontalPageMargin
                }
                color: Theme.secondaryColor
            }
        }
    }
}
