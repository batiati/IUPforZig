@echo off

set LIB_DIR=lib

set IUP_VERSION=3.30
set IUP_PLATFORM=Win64_dllw6
set IUP_ZIP=iup-%IUP_VERSION%_%IUP_PLATFORM%_lib.zip

echo Downloading %IUP_ZIP%...
curl --silent --progress-bar --output %IUP_ZIP% "https://ufpr.dl.sourceforge.net/project/iup/%IUP_VERSION%/Windows%%20Libraries/Dynamic/%IUP_ZIP%"
if not exist  %IUP_ZIP% (
  echo Failed to download.
  exit 1
)

if exist %LIB_DIR%\iup (
  rd /s /q %LIB_DIR%\iup
)

echo Extracting %IUP_ZIP%...
SET PS_DISABLE_PROGRESS="$ProgressPreference=[System.Management.Automation.ActionPreference]::SilentlyContinue"
powershell -Command "%PS_DISABLE_PROGRESS%;Expand-Archive %IUP_ZIP% -DestinationPath %LIB_DIR%\iup"
del /q %IUP_ZIP%

set CD_VERSION=5.14
set CD_PLATFORM=Win64_dllw6
set CD_ZIP=cd-%CD_VERSION%_%CD_PLATFORM%_lib.zip

echo Downloading %CD_ZIP%...
curl --silent --progress-bar --output %CD_ZIP% "https://ufpr.dl.sourceforge.net/project/canvasdraw/%CD_VERSION%/Windows%%20Libraries/Dynamic/%CD_ZIP%"
if not exist  %CD_ZIP% (
  echo Failed to download.
  exit 1
)

if exist %LIB_DIR%\cd (
  rd /s /q %LIB_DIR%\cd
)

echo Extracting %CD_ZIP%...
SET PS_DISABLE_PROGRESS="$ProgressPreference=[System.Management.Automation.ActionPreference]::SilentlyContinue"
powershell -Command "%PS_DISABLE_PROGRESS%;Expand-Archive %CD_ZIP% -DestinationPath %LIB_DIR%\cd"
del /q %CD_ZIP%

set IM_VERSION=3.15
set IM_PLATFORM=Win64_dllw6
set IM_ZIP=im-%IM_VERSION%_%IM_PLATFORM%_lib.zip

echo Downloading %IM_ZIP%...
curl --silent --progress-bar --output %IM_ZIP% "https://ufpr.dl.sourceforge.net/project/imtoolkit/%IM_VERSION%/Windows%%20Libraries/Dynamic/%IM_ZIP%"
if not exist  %IM_ZIP% (
  echo Failed to download.
  exit 1
)

if exist %LIB_DIR%\im (
  rd /s /q %LIB_DIR%\im
)

echo Extracting %IM_ZIP%...
SET PS_DISABLE_PROGRESS="$ProgressPreference=[System.Management.Automation.ActionPreference]::SilentlyContinue"
powershell -Command "%PS_DISABLE_PROGRESS%;Expand-Archive %IM_ZIP% -DestinationPath %LIB_DIR%\im"
del /q %IM_ZIP%