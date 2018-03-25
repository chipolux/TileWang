import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2


ApplicationWindow {
    title: "Tile Viewer"
    minimumWidth: 1280
    minimumHeight: 720

    property int colSpacing: 16
    property int rowSpacing: 16
    property int cols: tileSet.sourceSize.width / colSpacing
    property int rows: tileSet.sourceSize.height / rowSpacing
    property int currentIndex: 0
    property int currentCol: currentIndex % cols
    property int currentRow: currentIndex / cols

    FileDialog {
        id: fileDialog
        selectMultiple: false
        nameFilters: ["Image files (*.jpg *.png)"]

        onAccepted: tileSet.source = fileUrl
    }

    Column {
        id: infoColumn
        spacing: 5

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 20

        Label {
            id: imagePathLabel
            text: {
                if (tileSet.source != "") {
                    var path = tileSet.source.toString().replace(/^(file:\/{3})/, "")
                    return "<b>Image:</b> %1".arg(decodeURIComponent(path))
                } else {
                    return "<b>Image:</b> No image loaded..."
                }
            }
        }

        Label {
            text: "<b>Size:</b> %1:%2 or %3x%4".arg(cols).arg(rows).arg(tileSet.sourceSize.width).arg(tileSet.sourceSize.height)
            visible: tileSet.source != ""
        }

        Label {
            text: "<b>Index:</b> %1".arg(currentIndex)
            visible: tileSet.source != ""
        }

        Label {
            text: "<b>Position:</b> %1:%2".arg(currentCol).arg(currentRow)
            visible: tileSet.source != ""
        }

        Label {
            text: "<b>Offset:</b> %1x%2".arg(currentCol * colSpacing).arg(currentRow * rowSpacing)
            visible: tileSet.source != ""
        }
    }

    Button {
        id: loadImageButton
        text: "Load Image"

        onClicked: fileDialog.open()

        anchors.top: parent.top
        anchors.left: scaleSelector.left
        anchors.right: parent.right
        anchors.topMargin: 10
        anchors.rightMargin: 10
    }

    ComboBox {
        id: scaleSelector
        model: [1, 2, 3, 4, 5]
        displayText: "Scale: %1x".arg(currentText)

        anchors.top: loadImageButton.bottom
        anchors.right: parent.right
        anchors.margins: 10
    }

    Image {
        id: tileSet
        smooth: false
        width: sourceSize.width * scaleSelector.currentText
        height: sourceSize.height * scaleSelector.currentText

        property int rows: height / (rowSpacing * scaleSelector.currentText)
        property int cols: width / (colSpacing * scaleSelector.currentText)

        anchors.top: infoColumn.bottom
        anchors.left: parent.left
        anchors.margins: 10

        Grid {
            rows: tileSet.rows
            columns: tileSet.cols

            Repeater {
                model: tileSet.rows * tileSet.cols

                Rectangle {
                    width: colSpacing * scaleSelector.currentText
                    height: rowSpacing * scaleSelector.currentText
                    color: "transparent"
                    border.width: 2
                    border.color: currentIndex == index ? "orange" : "black"

                    MouseArea {
                        onClicked: currentIndex = index
                        anchors.fill: parent
                    }
                }
            }
        }
    }
}
