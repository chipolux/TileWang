from PyQt5.QtCore import QObject, pyqtSlot
from PyQt5.QtGui import QClipboard, QGuiApplication


class Clipboard(QObject):
    def __init__(self, parent=None):
        super().__init__(parent)
        self._clipboard = QGuiApplication.clipboard()

    @pyqtSlot(str)
    def setText(self, text):
        self._clipboard.setText(text, QClipboard.Clipboard)
