import QtQuick 1.1

Rectangle {
    width: 640
    height: 480

    color: "black"

    property string sessionAddress: ""

    TextEdit {
        id: teacher
        anchors.fill: parent
        color: Qt.rgba(255, 255, 255, 0.3)
        anchors.margins: 10
        font.pixelSize: 18

        TextEdit {
            id: editor
            anchors.fill: parent
            color: Qt.rgba(255, 255, 255, 1)
	        font.pixelSize: 18
        }
    }

    Timer {
        id: timer
        interval: 500
        repeat: true

        onTriggered: {
            var request = new XMLHttpRequest();
            request.open("GET", "http://" + sessionAddress + ":1995/");
            request.onreadystatechange = function(state) {
                if (request.readyState == 4)
                    teacher.text = request.responseText;
            }

            request.send();
        }
    }

    ListView {
        id: listView
        anchors.verticalCenter: parent.verticalCenter
        anchors.fill: parent
        anchors.topMargin: 20
        anchors.bottomMargin: 40

        spacing: 1

        delegate: Rectangle {
            height: 35
            anchors.left: parent.left
            anchors.right: parent.right
            color: Qt.rgba(255, 255, 255, 0.3)
            anchors.leftMargin: 40
            anchors.rightMargin: 40
            radius: 2

            Text {
                anchors.fill: parent
                text: name
                color: "white"
                font.pixelSize: 16
                horizontalAlignment: Text.Center
                verticalAlignment: Text.AlignVCenter
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    listView.visible = false;
                    button.visible = false;
                    editor.focus = true;
                    sessionAddress = address;
                    timer.start();
                }
            }
        }

        model: ListModel {
            id: model
        }

        Connections {
            target: session

            onNewSession: {
                model.append({ name: name, address: address });
            }
        }
    }

    Rectangle {
        id: button

        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        height: 40
        width: 200
        color: "transparent"
        border.color: Qt.rgba(255, 255, 255, 0.3)
        border.width: 1
        radius: 6
        anchors.bottomMargin: 20

        Text {
            horizontalAlignment: Text.Center
            verticalAlignment: Text.AlignVCenter
            anchors.fill: parent
            text: "Encontrar sessões"
            color: "white"
            font.pixelSize: 18
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                session.sendDiscover();
            }
        }
    }
}
