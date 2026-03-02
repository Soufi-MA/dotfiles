import QtQuick 2.0
import SddmComponents 2.0

Rectangle {
    width: Screen.width
    height: Screen.height
    color: "transparent"

    // Background image from config
    Image {
        anchors.fill: parent
        source: config.background
        fillMode: Image.PreserveAspectCrop  // Adjust as needed
    }

    // Login form on left half
    Rectangle {
        id: loginForm
        width: parent.width / 2
        height: parent.height
        anchors.left: parent.left
        color: "transparent"  // Or add semi-transparent background if desired

        Column {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 50  // Padding from left edge
            spacing: 10

            TextField {
                id: userField
                width: 200
                placeholderText: "Username"
                focus: true
            }

            PasswordBox {
                id: passField
                width: 200
                placeholderText: "Password"
            }

            ComboBox {
                id: sessionBox
                width: 200
                model: sessionModel
                currentIndex: sessionModel.lastIndex
            }

            Button {
                text: "Login"
                onClicked: sddm.login(userField.text, passField.text, sessionBox.currentIndex)
            }
        }
    }

    // Optional: Clock on right or elsewhere
    Clock {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 20
    }
}
