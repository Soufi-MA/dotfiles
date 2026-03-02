import QtQuick 2.15
import QtQuick.Controls 2.15

import "Components"

Pane {
    id: root

    height: Screen.height
    width: Screen.width
    padding: 0

    palette.window: config.BackgroundColor
    palette.highlight: config.HighlightBackgroundColor
    palette.highlightedText: config.HighlightTextColor
    palette.buttonText: config.HoverSystemButtonsIconsColor

    font.family: "ESPACION"
    font.pointSize: 12
    
    focus: true

    Image {
        id: backgroundImage
        x: 0
        y: 0
        z: 1
        clip: true
        source: config.Background
        asynchronous: false
        cache: true
        mipmap: true
        smooth: true
    }

    Rectangle {
        id: formBackground
        anchors.fill: form
        z: 2
        color: config.FormBackgroundColor || "transparent"
    }

    LoginForm {
        id: form
        height: parent.height
        width: Math.floor(parent.width / 2.5)
        x: config.FormPosition === "center" ? (parent.width - width) / 2 :
           config.FormPosition === "right"  ? parent.width - width :
           0
        z: 3
    }

    MouseArea {
        anchors.fill: backgroundImage
        onClicked: parent.forceActiveFocus()
    }
}
