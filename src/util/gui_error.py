import sys
import traceback

from PySide6.QtCore import QCoreApplication, Qt
from PySide6.QtWidgets import QMessageBox


ERROR_MSG = '發生錯誤，程式即將關閉'
UNKNOWN_ERROR_MSG = 'Application terminated due to an unexpected error.'


def exception_hook(exc_type, exc_value, exc_traceback, exit_app=True):
    try:
        # Generate error msg and info.
        err_msg = str(exc_value)
        exc_info = ''.join(traceback.format_exception(exc_type, exc_value, exc_traceback))

        # Display error msg.
        msg_box = QMessageBox(
            QMessageBox.Critical,
            ERROR_MSG,
            str(err_msg),
            QMessageBox.Ok
        )
        msg_box.setModal(True)
        msg_box.setWindowFlags(Qt.WindowStaysOnTopHint)
        msg_box.setDetailedText(exc_info)
        msg_box.exec()
    except:
        msg_box = QMessageBox(
            QMessageBox.Critical,
            ERROR_MSG,
            UNKNOWN_ERROR_MSG,
            QMessageBox.Ok
        )
        msg_box.setModal(True)
        msg_box.setWindowFlags(Qt.WindowStaysOnTopHint)
        msg_box.exec()
    finally:
        if exit_app:  # Force application to quit.
            QCoreApplication.quit()
            sys.exit(1)
