import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2


ApplicationWindow {
    title: "TileWang"
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

    Rectangle {
        id: controlsBackground
        color: "lemonchiffon"
        opacity: 0.98

        anchors.top: parent.top
        anchors.bottom: tileSizeRow.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottomMargin: -15
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
        width: 200

        onClicked: fileDialog.open()

        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 10
    }

    ComboBox {
        id: scaleSelector
        model: [0.5, 0.75, 1, 2, 3, 4, 5]
        currentIndex: 2
        displayText: "Scale: %1x".arg(currentText)
        width: 200

        anchors.top: loadImageButton.bottom
        anchors.right: parent.right
        anchors.margins: 10
    }

    Row {
        id: tileSizeRow

        anchors.top: scaleSelector.bottom
        anchors.right: parent.right
        anchors.margins: 10

        TextField {
            id: tileWidth
            text: "16"
            width: 75
            horizontalAlignment: Text.AlignHCenter
        }

        Label {
            text: "x"
            width: 20
            horizontalAlignment: Text.AlignHCenter
            anchors.verticalCenter: parent.verticalCenter
        }

        TextField {
            id: tileHeight
            text: "16"
            width: 75
            horizontalAlignment: Text.AlignHCenter
        }

        Image {
            source: "done_black.svg"
            width: 30
            height: 30
            anchors.verticalCenter: parent.verticalCenter

            MouseArea {
                onClicked: {
                    colSpacing = tileWidth.text
                    rowSpacing = tileHeight.text
                }
                anchors.fill: parent
            }
        }
    }

    ScrollView {
        z: -1
        contentWidth: tileSet.sourceSize.width * scaleSelector.currentText
        contentHeight: tileSet.sourceSize.height * scaleSelector.currentText

        anchors.top: controlsBackground.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 10

        Image {
            id: tileSet
            smooth: false
            width: sourceSize.width * scaleSelector.currentText
            height: sourceSize.height * scaleSelector.currentText

            property int rows: height / (rowSpacing * scaleSelector.currentText)
            property int cols: width / (colSpacing * scaleSelector.currentText)

            Grid {
                rows: tileSet.rows
                columns: tileSet.cols

                Repeater {
                    model: tileSet.rows * tileSet.cols

                    Rectangle {
                        width: colSpacing * scaleSelector.currentText
                        height: rowSpacing * scaleSelector.currentText
                        color: "transparent"
                        border.width: currentIndex == index ? 4 : 2
                        border.color: currentIndex == index ? "orange" : "darkslateblue"

                        MouseArea {
                            onClicked: currentIndex = index
                            anchors.fill: parent
                        }
                    }
                }
            }
        }
    }
}
