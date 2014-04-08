import QtQuick 1.1

Rectangle {
    width: 360
    height: 360

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
            request.open("POST", "http://localhost:8080/");
            request.send(editor.text);
        }
    }
}
