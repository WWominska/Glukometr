import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground
{
    BackgroundItem {
        anchors.fill: parent
        opacity: 0.15
        Image {
            id: coverBgImage
            fillMode: Image.PreserveAspectCrop
            anchors.fill: parent
            source: "qrc:/assets/cover/background.svg"
        }
        OpacityRampEffect {
            slope: 1.0
            offset: 0.15
            sourceItem: coverBgImage
            direction: OpacityRamp.TopToBottom
        }
    }

    Label {
        id: latestMeasurementsLabel
        x: Theme.horizontalPageMargin - (Theme.itemSizeExtraSmall/4)
        y: Theme.paddingMedium
        text: qsTr("COVER_PAGE_TITLE")
        font.pixelSize: Theme.fontSizeMedium
        maximumLineCount: 2
        wrapMode: Text.WordWrap
        lineHeight: 0.8
        height: implicitHeight/0.8
        verticalAlignment: Text.AlignVCenter
    }

    SilicaListView {
        anchors {
            top: latestMeasurementsLabel.bottom
            left: parent.left
            right: parent.right
            topMargin: Theme.paddingSmall
            leftMargin: Theme.horizontalPageMargin
            rightMargin: Theme.horizontalPageMargin
            bottom: coverActionArea.top
        }
        width: parent.width
        model: measurements.model

        delegate: BackgroundItem {
            id: delegate
            visible: index < 3
            contentHeight: measurementColumn.height

            GlassItem
            {
                id: glassItem
                x: -width/2
                width: Theme.itemSizeExtraSmall
                height: width
                anchors.verticalCenter: measurementColumn.verticalCenter
                color: thresholds.evaluateMeasurement(model.value, model.meal)
            }

            Column {
                id: measurementColumn
                anchors {
                    left: glassItem.right
                    right: parent.right
                }

                Label {
                    id: itemLabel
                    width: parent.width
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    truncationMode: TruncationMode.Fade
                    text: model.value
                }
                Label {
                    width: parent.width

                    font.pixelSize:  Theme.fontSizeTiny
                    truncationMode: TruncationMode.Fade
                    color: Theme.secondaryColor
                    text: new Date(model.timestamp*1000).toLocaleString(Qt.locale(),"dd.MM.yy    HH:mm")
                }
            }
        }
    }

    CoverActionList
    {
        id: coverAction

        CoverAction
        {
            iconSource: "image://theme/icon-cover-new"
            onTriggered:
            {
                application.activate()
                if (!application.measurementPageOpen)
                    application.openAddMeasurementDialog()
            }
        }

        CoverAction
        {
            iconSource: "image://theme/icon-s-bluetooth"
            onTriggered:
            { 
                application.activate()
                if (!application.bluetoothPageOpen && !application.isTutorialEnabled)
                    application.pageStack.push("qrc:/assets/pages/DeviceList.qml")
            }
        }
    }
}
