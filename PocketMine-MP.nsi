!include MUI2.nsh
!include LogicLib.nsh
!include x64.nsh

BrandingText "https://pmmp.io"
InstallDir "$EXEDIR\PocketMine-MP"
Name "PocketMine-MP"
OutFile "PocketMine-MP.exe"
RequestExecutionLevel "user"
SpaceTexts "none"
ShowInstDetails "nevershow"

Function createshortcut
    CreateShortcut "$DESKTOP\PocketMine-MP.lnk" "$INSTDIR\start.cmd" "" $EXEFILE 0
FunctionEnd

Function .onInit
    ${IfNot} ${RunningX64}
        MessageBox MB_OK "PocketMine-MP is no longer supported on 32-bit systems."
        Abort
    ${EndIf}
FunctionEnd

!define MUI_WELCOMEFINISHPAGE_BITMAP "welcome-finish.bmp"
!define MUI_ABORTWARNING
!define MUI_FINISHPAGE_RUN "start.cmd"
!define MUI_FINISHPAGE_RUN_TEXT "Run PocketMine-MP"
!define MUI_FINISHPAGE_SHOWREADME
!define MUI_FINISHPAGE_SHOWREADME_TEXT "Create Desktop Shortcut"
!define MUI_FINISHPAGE_SHOWREADME_FUNCTION createshortcut
!define MUI_WELCOMEPAGE_TITLE "Welcome to the PocketMine-MP Installation Wizard"
!define MUI_FINISHPAGE_TITLE "Complete PocketMine-MP Setup"
!define MUI_ICON "icon.ico"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_LANGUAGE "English"

Section "Install"
    SetOutPath $INSTDIR
    SetDetailsPrint none
    inetc::get /NOCANCEL https://jenkins.pmmp.io/job/PocketMine-MP/lastStableBuild/artifact/PocketMine-MP.phar PocketMine-MP.phar
    inetc::get /NOCANCEL https://jenkins.pmmp.io/job/PocketMine-MP/lastStableBuild/artifact/start.cmd start.cmd
    inetc::get /NOCANCEL https://jenkins.pmmp.io/job/${PHP_JOB_NAME}/lastSuccessfulBuild/artifact/${PHP_ARTIFACT_NAME} $TEMP\${PHP_ARTIFACT_NAME}
    ZipDLL::extractall $TEMP\${PHP_ARTIFACT_NAME} $INSTDIR
    ExecWait '"$INSTDIR\vc_redist.x64.exe" /install /passive /norestart'  
    Delete "$INSTDIR\vc_redist.x64.exe"  
SectionEnd
