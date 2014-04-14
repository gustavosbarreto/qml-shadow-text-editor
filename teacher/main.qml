import QtQuick 1.1

Rectangle {
    width: 640
    height: 480

    color: "black"

    TextEdit {
        id: editor
        anchors.fill: parent
        focus: true
        color: Qt.rgba(255, 255, 255, 1)
        anchors.margins: 10
        font.pixelSize: 18
    }

    Timer {
        running: true
        interval: 500
        repeat: true

        onTriggered: {
            var request = new XMLHttpRequest();
            request.open("POST", "http://localhost:1995/");
            request.send(editor.text);
        }
    }
}
