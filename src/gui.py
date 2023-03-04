import os
import sys

from PySide6.QtWidgets import QApplication

from setting import APP_ROOT
from util import gui_error
from ui_component.main_window import MainWindow


if __name__ == '__main__':
    # Change working directory.
    os.chdir(APP_ROOT)

    # Define error handler.
    sys.excepthook = gui_error.exception_hook

    # Activate GUI.
    app = QApplication(sys.argv)
    window = MainWindow()
    window.show()
    sys.exit(app.exec())
