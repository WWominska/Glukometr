import QtQuick 2.0

Item {
    property bool notFirstRun: appSettings.get("conf", "NotFirstRun", false)
    property string phoneNumber: appSettings.get("conf", "PhoneNumber", "")

    onNotFirstRunChanged: appSettings.set("conf", "NotFirstRun", notFirstRun)
    onPhoneNumberChanged: appSettings.set("conf", "PhoneNumber", phoneNumber)
}
