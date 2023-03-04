import configparser
from pathlib import Path


class ConfigLoader(configparser.ConfigParser):
    _config_path = None

    def __init__(self, filename=None, encoding='utf-8', path_root='.'):
        # Initialize.
        super(ConfigLoader, self).__init__(interpolation=configparser.ExtendedInterpolation())
        self.encoding = encoding
        self.path_root = path_root

        # Define format for saving option.
        self.optionxform = lambda option: option.upper()

        # Load config.
        if filename is not None:
            self.read(filename, encoding)

    def read(self, filename, encoding=None):
        self.config_path = filename
        if not self.config_path.exists():
            raise FileNotFoundError(f'[ERROR] Config file does not exist. ({self.config_path})')
        if encoding is not None:
            self.encoding = encoding
        super(ConfigLoader, self).read(self.config_path, encoding=self.encoding)

    def save(self, save_to=None, encoding=None):
        save_to = Path(save_to) if save_to else self.config_path
        encoding = encoding if encoding is not None else self.encoding
        self.write(open(save_to, 'w', encoding=encoding))

    def getpath(self, section, option, to_string=False):
        path = Path(self.get(section, option))
        abs_path = path.resolve() if path.is_absolute() else (self._path_root / path).resolve()
        return str(abs_path) if to_string else abs_path

    def getlist(self, section, option, value_type='str', sep=',', chars=None):
        """
        Return a list from a ConfigParser option.
        By default, split on a comma and strip whitespaces.

        :param section: the same as ConfigParser section
        :param option: the same as ConfigParser option
        :param sep: separator for splitting option value
        :param chars: chars to strip
        :param value_type: 'str', 'int', 'float'
        :return: list
        """
        option_value_str = self.get(section, option)
        if option_value_str == '':
            return []

        option_list = [value.strip(chars) for value in option_value_str.split(sep)]
        if value_type == 'int':
            return list(map(int, option_list))
        elif value_type == 'float':
            return list(map(float, option_list))
        else:
            return option_list

    def set(self, section, option, value=None, recording_func=None):
        if recording_func is not None and self.has_option(section, option):
            old_val = self.get(section, option)
            recording_func(section, option, old_val, value)

        super().set(section, option, value)

    @property
    def config_path(self):
        return self._config_path

    @config_path.setter
    def config_path(self, _config_path):
        _config_path = Path(_config_path)
        self._config_path = _config_path if _config_path.is_absolute() else self.path_root / _config_path

    @property
    def path_root(self):
        return self._path_root

    @path_root.setter
    def path_root(self, _path_root):
        self._path_root = Path(_path_root)

    @property
    def encoding(self):
        return self._encoding

    @encoding.setter
    def encoding(self, _encoding):
        self._encoding = _encoding
