import QtQuick 2.0
import QtQuick.Controls 2.3
import ".."
import "../components"

Page
{
    Component.onCompleted: reminders.get()

    function makeReminder(text, reminder_type, when, repeating)
    {
        reminders.remind(text, reminder_type, when, repeating,
                                         function () { reminders.get() })
    }

    function reminderTypeToString(type)
    {
        switch (type)
        {
        case 0: return "Przypomnienie o pomiarze";
        case 1: return "Przypomnienie o lekach";
        case 2: return "Przypomnienie o jedzeniu";
        }
    }

    ListView
    {
        anchors.fill: parent
//        PullDownMenu
//        {
//            MenuItem
//            {
//                text: "Dodaj przypomnienie"
//                onClicked: {
//                    var dialog = pageStack.push(Qt.resolvedUrl("qrc:/assets/dialogs/AddReminder.qml"))
//                    dialog.accepted.connect(function()
//                    {
//                        var date = new Date();
//                        if (date.getHours() > dialog.selectedHour) {
//                            date.setDate(date.getDate() + 1); // hcemy jurto
//                        }
//                        date.setHours(dialog.selectedHour)
//                        date.setMinutes(dialog.selectedMinute)
//                        reminders.addReminder(dialog.reminderType, date, dialog.repeating)
//                    })
//                }
//            }
//        }

        model: reminders.model
        header: PageHeader { title: "Przypomnienia" }
        delegate: ListItem
        {
            id:list
            //RemorseItem { id: remorse }
            //contentHeight: column.childrenRect.height + 2*Theme.paddingSmall
            menu: Menu
            {
                MenuItem
                {
                    text: "Usuń"
                    onClicked: remorse.execute(list, "Usunięcie powiadomienia", function()
                    {
                        reminders.cancel(cookie, function ()
                        {
                            reminders.remove(id)
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
