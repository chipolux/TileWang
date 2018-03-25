import sys


def run():
    from PyQt5.QtGui import QGuiApplication, QIcon
    from PyQt5.QtQml import QQmlApplicationEngine

    app = QGuiApplication(sys.argv)
    app.setWindowIcon(QIcon('app/ui/tile-viewer.ico'))

    # if we don't set our app as the engines parent it may not die when our
    # application is shutdown and can cause crashes during exit if it tries to
    # do things like load images, etc.
    engine = QQmlApplicationEngine(app)
    # Even if we ensure that or QML engine has it's parent set to the
    # application it can hang when we close the app if we don't schedule it's
    # deletion for when the app is quitting.
    app.aboutToQuit.connect(engine.deleteLater)

    engine.load('app/ui/TileViewer.qml')
    views = engine.rootObjects()
    if not views:
        sys.exit(1)
    for view in views:
        view.show()

    sys.exit(app.exec_())


if __name__ == '__main__':
    run()
