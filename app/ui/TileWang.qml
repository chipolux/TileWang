import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2


ApplicationWindow {
    title: "TileWang"
    minimumWidth: 1280
    minimumHeight: 720

    property int fontSize: 14
    property int colSpacing: 16
    property int rowSpacing: 16
    property int cols: tileSet.sourceSize.width / colSpacing
    property int rows: tileSet.sourceSize.height / rowSpacing
    property int currentIndex: 0
    property int currentCol: currentIndex % cols
    property int currentRow: currentIndex / cols

    function setTileSize() {
        colSpacing = tileWidth.text;
        rowSpacing = tileHeight.text;
    }

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
        anchors.bottom: tileSet.source != "" ? infoColumn.bottom : tileSizeRow.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottomMargin: -15
    }

    Column {
        id: infoColumn
        spacing: 5

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 15

        Label {
            id: imagePathLabel
            text: {
                var template = "<b>Image:</b> <font color=\"blue\">%1</font>";
                if (tileSet.source != "") {
                    var path = tileSet.source.toString().replace(/^(file:\/{3})/, "");
                    return template.arg(decodeURIComponent(path));
                } else {
                    return template.arg("No image loaded, click here to load one...");
                }
            }
            font.pixelSize: fontSize

            MouseArea {
                anchors.fill: parent

                onClicked: fileDialog.open()
            }
        }

        Label {
            text: "<b>Size:</b> %1:%2 or %3x%4".arg(cols).arg(rows).arg(tileSet.sourceSize.width).arg(tileSet.sourceSize.height)
            visible: tileSet.source != ""
            font.pixelSize: fontSize
        }

        Label {
            text: "<b>Index:</b> %1".arg(currentIndex)
            visible: tileSet.source != ""
            font.pixelSize: fontSize

            MouseArea {
                onClicked: clipboard.setText("%1\n".arg(currentIndex))

                anchors.fill: parent
            }
        }

        Label {
            text: "<b>Position:</b> %1:%2".arg(currentCol).arg(currentRow)
            visible: tileSet.source != ""
            font.pixelSize: fontSize

            MouseArea {
                onClicked: clipboard.setText("%1\t%2\n".arg(currentCol).arg(currentRow))

                anchors.fill: parent
            }
        }

        Label {
            text: "<b>Offset:</b> %1 x %2".arg(currentCol * colSpacing).arg(currentRow * rowSpacing)
            visible: tileSet.source != ""
            font.pixelSize: fontSize

            MouseArea {
                onClicked: clipboard.setText("%1\t%2\n".arg(currentCol * colSpacing).arg(currentRow * rowSpacing))

                anchors.fill: parent
            }
        }
    }

    Image {
        id: reloadButton
        source: "refresh_black.svg"
        enabled: tileSet.source != ""
        opacity: enabled ? 1.0 : 0.5
        sourceSize.height: scaleSelector.height * 0.8

        MouseArea {
            onClicked: tileSet.source = fileDialog.fileUrl
            anchors.fill: parent
        }

        anchors.verticalCenter: scaleSelector.verticalCenter
        anchors.right: scaleSelector.left
        anchors.margins: 10
    }

    ComboBox {
        id: scaleSelector
        model: [0.5, 0.75, 1, 2, 3, 4, 5]
        currentIndex: 2
        displayText: "Scale: %1x".arg(currentText)
        width: 190 - reloadButton.width
        font.pixelSize: fontSize

        anchors.top: parent.top
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
            width: 70
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: fontSize

            onEditingFinished: setTileSize()
        }

        Label {
            text: "x"
            width: 20
            horizontalAlignment: Text.AlignHCenter
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: fontSize
        }

        TextField {
            id: tileHeight
            text: "16"
            width: 70
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: fontSize

            onEditingFinished: setTileSize()
        }

        Item {
            id: tileSizeSpacer
            width: 8
            height: 1
        }

        Image {
            source: "done_black.svg"
            sourceSize.height: tileSizeRow.height * 0.8
            anchors.verticalCenter: parent.verticalCenter

            MouseArea {
                onClicked: setTileSize()
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
            cache: false
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
