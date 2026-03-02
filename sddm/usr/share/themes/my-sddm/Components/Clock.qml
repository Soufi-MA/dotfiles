import QtQuick 2.15
import QtQuick.Controls 2.15

Column {
    id: clock

    width: parent.width / 2
    spacing: 0

    Label {
        id:headerTextLabel

        anchors.horizontalCenter: parent.horizontalCenter

        font.pointSize: root.font.pointSize * 3
        color: config.HeaderTextColor
        renderType: Text.QtRendering
        text: ""
    }

    Label {
        id: timeLabel

        anchors.horizontalCenter: parent.horizontalCenter

        font.pointSize: root.font.pointSize * 9
        font.bold: true
        color: config.TimeTextColor
        renderType: Text.QtRendering

        function updateTime() {
            text = new Date().toLocaleTimeString(Qt.locale(""), "HH:mm")
        }
    }

    Label {
        id: dateLabel

        anchors.horizontalCenter: parent.horizontalCenter
        
        color: config.DateTextColor
        font.pointSize: root.font.pointSize * 2
        font.bold: true
        renderType: Text.QtRendering

        function updateTime() {
            text = new Date().toLocaleDateString(Qt.locale(""), Locale.LongFormat)
        }
    }

    Timer {
        interval: 1000
        repeat: true
        running: true
        onTriggered: {
            dateLabel.updateTime()
            timeLabel.updateTime()
        }
    }

    Component.onCompleted: {
        dateLabel.updateTime()
        timeLabel.updateTime()
    }
}
