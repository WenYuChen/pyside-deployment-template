!include "MUI.nsh" # include Modern UI
!include "Sections.nsh"
!include "LogicLib.nsh" # ${if}

# ----------------------------------------------------------------------
# 軟體資訊
# ----------------------------------------------------------------------
!define STR_AppName "PySide-GUI"  # 軟體名稱
!define STR_Publisher "Jesse Chen"  # 發佈單位
!define STR_HomepageUrl ""  # 官網連結
!define /date STR_ReleasedYear "%Y"  # 發行年分
!define STR_AppDir "..\..\build\PySide-GUI"  # 執行檔資料夾
!define STR_StartupApp "PySide-GUI"  # 執行檔名稱
!define /file STR_Version "${STR_AppDir}\VERSION.txt"  # 版本號
!define STR_IconPath "res\img\logo.ico"  # 軟體 icon 在資料夾中的相對路徑


# ----------------------------------------------------------------------
# 安裝精靈設定
# ----------------------------------------------------------------------
Name "${STR_AppName} v${STR_Version}"  # 安裝精靈顯示名稱
OutFile "..\..\installer\${STR_AppName}-${STR_Version}-Setup.exe"  # 安裝精靈儲存路徑
InstallDir "$PROGRAMFILES\${STR_AppName}"  # 預設的安裝目錄
!define STR_DesktopLink "${STR_StartupApp}"  # 桌面捷徑名稱
!define STR_UnInstaller "uninstaller"  # 解除安裝檔案名稱
BrandingText /TRIMRIGHT "$(LNG_BrandingText)"


# ----------------------------------------------------------------------
# 頁面設定
# ----------------------------------------------------------------------
ShowInstDetails show  # 安裝過程顯示詳細的安裝訊息
ShowUnInstDetails show  # 解除安裝過程顯示詳細的安裝訊息

!define MUI_ICON ${STR_AppDir}\${STR_IconPath}  # 設定安裝精靈的 icon
!define MUI_UNICON ${STR_AppDir}\${STR_IconPath}  # 設定解除安裝的 icon
!define MUI_ABORTWARNING  # 當用戶要關閉安裝程序時, 顯示一個警告消息框
!define MUI_UNABORTWARNING  # 當用戶要關閉卸載程序時, 顯示一個警告消息框
!define MUI_FINISHPAGE_NOAUTOCLOSE  # 不自動跳到完成頁面, 允許用戶檢查安裝記錄
!define MUI_UNFINISHPAGE_NOAUTOCLOSE  # 不自動跳到完成頁面, 允許用戶檢查卸載記錄

# 歡迎頁面
!insertmacro MUI_PAGE_WELCOME

# 路徑選擇頁面
!insertmacro MUI_PAGE_DIRECTORY

# 執行安裝頁面
!insertmacro MUI_PAGE_INSTFILES

# 安裝完成頁面
!define MUI_FINISHPAGE_LINK "Copyright © ${STR_ReleasedYear} ${STR_Publisher}. All rights reserved."
!define MUI_FINISHPAGE_LINK_LOCATION "${STR_HomepageUrl}"
!insertmacro MUI_PAGE_FINISH

# 移除確認頁面
!insertmacro MUI_UNPAGE_CONFIRM

# 執行移除頁面
!insertmacro MUI_UNPAGE_INSTFILES


# ----------------------------------------------------------------------
# 語系設定
# ----------------------------------------------------------------------
!insertmacro MUI_LANGUAGE "TradChinese"
!insertmacro MUI_LANGUAGE "English"

LangString LNG_BrandingText ${LANG_TRADCHINESE} "${STR_AppName} ${STR_Version}"
LangString LNG_BrandingText ${LANG_ENGLISH} "${STR_AppName} ${STR_Version}"

LangString LNG_InstallFail ${LANG_TRADCHINESE} "安裝失敗。"
LangString LNG_InstallFail ${LANG_ENGLISH} "Installation failed."

LangString LNG_IsExecuting ${LANG_TRADCHINESE} "正在運行中，請關閉後再執行。"
LangString LNG_IsExecuting ${LANG_ENGLISH} "is still running, please terminate the application."



# ----------------------------------------------------------------------
# 定義安裝流程
# ----------------------------------------------------------------------
Function .onInit
    Call CheckIfProcessRunning
    !insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd

Section "$(^Name)"
    SectionIn RO # Read Only

    # Installation.
    DetailPrint "Installing $(^Name)..."
    SetOutPath "$INSTDIR"  # Change working directory.
    SetOverwrite off
    File /r "${STR_AppDir}\*"  # Copy all files from executable directory.

    # Create shortcuts.
    DetailPrint "Create shortcuts on Desktop..."
    CreateShortCut "$Desktop\${STR_DesktopLink}.lnk" "$INSTDIR\${STR_StartupApp}" "" "$INSTDIR\${STR_IconPath}" 0 SW_SHOWNORMAL

    # Create uninstaller.
    DetailPrint "Create uninstaller."
    WriteUninstaller "$INSTDIR\${STR_UnInstaller}.exe"

    DetailPrint "Complete."
SectionEnd


#----------------------------------------------------------------------
# 定義解除安裝流程
#----------------------------------------------------------------------
Function un.onInit
    Call un.CheckIfProcessRunning
    !insertmacro MUI_UNGETLANGUAGE
FunctionEnd

Section "uninstall"
    # Remove shortcuts.
    Delete /REBOOTOK "$Desktop\${STR_DesktopLink}.lnk"

    # Remove uninstaller.
    Delete /REBOOTOK "$INSTDIR\${STR_UnInstaller}.exe"

    # Remove directory.
    RMDir /REBOOTOK /R "$INSTDIR"

    SetAutoClose true
SectionEnd


#----------------------------------------------------------------------
# Functions & Macros
#----------------------------------------------------------------------
!macro CheckIfProcessRunning.Macro un
    Function ${un}CheckIfProcessRunning
        !insertmacro CheckProcess "${STR_StartupApp}.exe" "${STR_StartupApp}.exe"
    FunctionEnd
!macroend

!macro CheckProcess ProcessName DisplayName
    nsProcess::_FindProcess "${ProcessName}"
    Pop $R0
    ${If} $R0 = 0
        MessageBox MB_OK|MB_ICONEXCLAMATION "${DisplayName} $(LNG_IsExecuting)" /SD IDOK
        Abort
    ${EndIf}
!macroend


; Insert function as an installer and uninstaller function.
!insertmacro CheckIfProcessRunning.Macro ""
!insertmacro CheckIfProcessRunning.Macro "un."
