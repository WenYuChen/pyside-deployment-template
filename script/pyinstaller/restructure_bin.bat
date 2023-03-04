@setlocal EnableDelayedExpansion

@rem Initialize parameters.
@echo [restructure_bin.bat] Initialize...
@set "BIN_DIR=%~dpnx1"
@set "LIB_DIR=%BIN_DIR%\lib"
@echo [restructure_bin.bat] Done.

@rem Create "lib" directory.
@echo [restructure_bin.bat] Create "lib" directory.
@mkdir "%LIB_DIR%"
@echo [restructure_bin.bat] Done.

@rem Move all dynamic files to "lib".
@echo [restructure_bin.bat] Move all .pyd files to "lib".
@move "%BIN_DIR%\*.pyd" "%LIB_DIR%"
@echo [restructure_bin.bat] Done.

@echo [restructure_bin.bat] Move all .dll files to "lib".
@move "%BIN_DIR%\*.dll" "%LIB_DIR%"
@echo [restructure_bin.bat] Done.

@rem Keep some dll files which is required by pyinstaller bootloader.
@echo [restructure_bin.bat] Keep some dll files which is required by pyinstaller bootloader.
@for %%i in (
    %LIB_DIR%\python*.dll
        ) do @(
    @echo %%i
    @move %%i %BIN_DIR%
)
@echo [restructure_bin.bat] Done.
