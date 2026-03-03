import QtQuick 2.15
import QtQuick.Layouts 1.15

ColumnLayout {
    id: batteryComponent
    spacing: root.font.pointSize * 0.55
    Layout.alignment: Qt.AlignHCenter

    property int capacity: 100
    property bool isCharging: false

    Timer {
        interval: 6000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: updateBattery()
    }

    function updateBattery() {
        let xhr = new XMLHttpRequest()
        xhr.open("GET", "file:///tmp/sddm-battery.txt", false)
        xhr.send()
        let lines = xhr.responseText.trim().split("\n")
        if (lines.length >= 2) {
            capacity = parseInt(lines[0])
            let stat = lines[1]
            isCharging = (stat === "Charging" || stat === "Full")
        }
    }

    property color batteryColor: isCharging ? config.TimeTextColor :
                               capacity > 20 ? "#4ade80" :
                               capacity > 10 ? "#f59e0b" : "#ef4444"

    // === Horizontal battery outline (20% smaller) ===
    Item {
        id: batteryIcon
        Layout.preferredWidth: root.font.pointSize * 5.0
        Layout.preferredHeight: root.font.pointSize * 2.0

        Rectangle {
            id: body
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            width: parent.width * 0.86
            height: parent.height * 0.92
            radius: height / 5
            color: "transparent"
            border.width: Math.max(2, root.font.pointSize * 0.16)
            border.color: batteryColor
        }

        Rectangle {
            id: tip
            anchors.left: body.right
            anchors.verticalCenter: body.verticalCenter
            width: parent.width * 0.11
            height: body.height * 0.55
            radius: height / 4
            color: batteryColor
        }

        Rectangle {
            id: fill
            anchors.left: body.left
            anchors.top: body.top
            anchors.bottom: body.bottom
            anchors.margins: body.border.width + 1.5
            width: Math.max(0, (body.width - 2 * body.border.width - 3) * (capacity / 100))
            radius: body.radius - body.border.width / 2
            color: batteryColor
        }
    }

    Text {
        Layout.alignment: Qt.AlignHCenter
        text: capacity + "%"
        font.pointSize: root.font.pointSize * 1.25
        font.bold: true
        color: config.DateTextColor
        renderType: Text.QtRendering
    }
}