import QtQuick 1.1

Rectangle {
    width: 360
    height: 360

    color: "black"

    TextEdit {
        id: teacher
        anchors.fill: parent
        color: Qt.rgba(255, 255, 255, 0.3)
        anchors.margins: 10
        font.pixelSize: 18

        TextEdit {
            anchors.fill: parent
            focus: true
            color: Qt.rgba(255, 255, 255, 1)
	        font.pixelSize: 18
        }
    }

    Timer {
        running: true
        interval: 500
        repeat: true

        onTriggered: {
            var request = new XMLHttpRequest();
            request.open("GET", "http://127.0.0.1:8080/");
            request.onreadystatechange = function(state) {
                if (request.readyState == 4)
                    teacher.text = request.responseText;
            }

            request.send();
        }
    }
}
