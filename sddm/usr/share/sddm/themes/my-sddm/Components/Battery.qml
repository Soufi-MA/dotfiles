import QtQuick 2.15
import QtQuick.Layouts 1.15

ColumnLayout {
    id: batteryComponent
    spacing: root.font.pointSize * 0.55
    Layout.alignment: Qt.AlignHCenter

    property int capacity: 100
    property bool isCharging: false

    Timer {
        interval: 8000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: updateBattery()
    }

    function updateBattery() {
        var batPath = "/sys/class/power_supply/BAT0"
        var capFile = batPath + "/capacity"
        var statFile = batPath + "/status"

        var xhrCap = new XMLHttpRequest()
        xhrCap.open("GET", "file://" + capFile, false)
        xhrCap.send()
        var cap = parseInt(xhrCap.responseText)

        if (isNaN(cap) || cap < 0 || cap > 100) {
            batPath = "/sys/class/power_supply/BAT1"
            capFile = batPath + "/capacity"
            statFile = batPath + "/status"
            xhrCap.open("GET", "file://" + capFile, false)
            xhrCap.send()
            cap = parseInt(xhrCap.responseText) || 100
        }

        var xhrStat = new XMLHttpRequest()
        xhrStat.open("GET", "file://" + statFile, false)
        xhrStat.send()
        var stat = xhrStat.responseText.trim()

        capacity = Math.max(0, Math.min(100, cap))
        isCharging = (stat === "Charging" || stat === "Full")
    }

    property color batteryColor: isCharging ? config.TimeTextColor :
                               capacity > 20 ? "#4ade80" :
                               capacity > 10 ? "#f59e0b" : "#ef4444"

    // === Horizontal battery outline (20% smaller) ===
    Item {
        id: batteryIcon
        Layout.preferredWidth: root.font.pointSize * 5.0
        Layout.preferredHeight: root.font.pointSize * 2.0

        // Body outline
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

        // Nub (tip)
        Rectangle {
            id: tip
            anchors.left: body.right
            anchors.verticalCenter: body.verticalCenter
            width: parent.width * 0.11
            height: body.height * 0.55
            radius: height / 4
            color: batteryColor
        }

        // Fill level (changes with capacity)
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

    // Percentage under the battery
    Text {
        Layout.alignment: Qt.AlignHCenter
        text: capacity + "%"
        font.pointSize: root.font.pointSize * 1.25
        font.bold: true
        color: config.DateTextColor
        renderType: Text.QtRendering
    }
}