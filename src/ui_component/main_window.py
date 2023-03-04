import datetime

from PySide6.QtGui import QIcon
from PySide6.QtWidgets import QMainWindow

from setting import APP_CFG
from util.ui_loader import load_ui


class MainWindow(QMainWindow):
    ui_src = APP_CFG.getpath('UI', 'MAIN_PAGE', True)

    def __init__(self):
        super(MainWindow, self).__init__()
        load_ui(self.ui_src, self)

        # Define window appearance.
        self.setWindowTitle(APP_CFG.get('APPLICATION', 'NAME'))
        self.setWindowIcon(QIcon(APP_CFG.getpath('IMAGE', 'LOGO', True)))
        self.copyright.setText(APP_CFG.get('TEXT', 'COPYRIGHT').format(YEAR=datetime.date.today().year))
