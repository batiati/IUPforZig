@echo off

set IUP_VERSION=3.30
set IUP_PLATFORM=Win64_dllw6
set IUP_ZIP=iup-%IUP_VERSION%_%IUP_PLATFORM%_lib.zip
set LIB_DIR=lib

echo Downloading %IUP_ZIP%...
curl --silent --progress-bar --output %IUP_ZIP% "https://ufpr.dl.sourceforge.net/project/iup/%IUP_VERSION%/Windows%%20Libraries/Dynamic/%IUP_ZIP%"
if not exist  %IUP_ZIP% (
  echo Failed to download.
  exit 1
)

if exist %LIB_DIR%\ (
  rd /s /q %LIB_DIR%
)

echo Extracting %IUP_ZIP%...
SET PS_DISABLE_PROGRESS="$ProgressPreference=[System.Management.Automation.ActionPreference]::SilentlyContinue"
powershell -Command "%PS_DISABLE_PROGRESS%;Expand-Archive %IUP_ZIP% -DestinationPath %LIB_DIR%"
del /q %IUP_ZIP%