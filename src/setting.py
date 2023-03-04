import sys
from pathlib import Path

from util.config_loader import ConfigLoader


# Determine the root directory.
APP_ROOT = Path(sys._MEIPASS) if getattr(sys, 'frozen', False) else Path(__file__).absolute().parents[0]

# Load version info.
APP_VERSION = (APP_ROOT/'VERSION.txt').read_text().strip()

# Define path to load app setting.
INI_PATH = APP_ROOT / 'setting.ini'

# Load config.
APP_CFG = ConfigLoader(INI_PATH, path_root=APP_ROOT)
