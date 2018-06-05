import QtQuick 2.0
import Sailfish.Silica 1.0


Dialog
{
    id:iDontKnow

    canAccept: unitFood.acceptableInput

    onDone:
    {
        if (result == DialogResult.Accepted)
        {
            value = nameField.text
        }
    }

    SilicaFlickable
    {
        VerticalScrollDecorator {}
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: column.childrenRect.height

        Column
        {
            id:column
            width: parent.width
            spacing: Theme.paddingSmall

            DialogHeader {id: header}
            SectionHeader
            {
                id: phoneNumberHead
                font.pixelSize: Theme.fontSizeLarge
                font.bold: true
                text: "Podaj numer telefonu"
            }

            TextField
            {
                id: unitFood
                focus: true
                width: parent.width
                inputMethodHints: Qt.ImhDialableCharactersOnly
                placeholderText: "88**8**88"
                font.pixelSize: Theme.fontSizeLarge
                validator: RegExpValidator { regExp: /^\(?[0-9]{1,3}\)? ?-?[0-9]{1,3} ?-?[0-9]{3,5} ?-?[0-9]{4}( ?-?[0-9]{3})? ?(\w{1,9}\s?\d{1,6})?$/ }
                maximumLength: 9
            }

//            Label
//            {
//                text: "Powyże numer telefonu w razie nieszczęśliwego wypadku"
//                anchors
//                {
//                    verticalCenter: parent.verticalCenter
//                    left: parent.left
//                    right: parenyt.right
//                    margins: Theme.paddingMedium
//                }
//                wrapMode: Text.WordWrap
//                font.pixelSize: Theme.fontSizeMedium
//                color: Theme.secondaryColor
//            }
        }
    }
}
