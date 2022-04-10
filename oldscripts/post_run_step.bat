@echo off

REM Main Loop
REM In case the .build-scripts folder was deleted for some reason, we don't want to continue running this so exit!
SETLOCAL ENABLEDELAYEDEXPANSION

if not exist "%YYprojectDir%\.build-scripts\" (
	echo Build Script Manager: Error! build-scripts directory does not exist... Please run again. Aborting...
	exit 1
)

REM Run all post-build run scripts!

REM Run the .build.bat versions first!
echo Build Script Manager: Running post-build build scripts...
for %%f in ("%~DP0.post-build\*.build.bat") do (
	echo Build Script Manager: Executing: %%~nxf.
	start /B /wait cmd /C "%%f"
)

for /f "delims=" %%f in ('dir /b /o:n "%YYprojectDir%\.build-scripts\*"') do (
	set __filePath="%YYprojectDir%\.build-scripts\%%f\post_build_step.bat"
	if exist "!__filePath!" (
		echo Build Script Manager: Executing: "!__filePath!"
		start /B /wait cmd /C "!__filePath!"
	)
)

REM Run the .run.bat versions now!
echo Build Script Manager: Running post-build run scripts...
for %%f in ("%~DP0.post-build\*.run.bat") do (
	echo Build Script Manager: Executing: %%~nxf.
	start /B /wait cmd /C "%%f"
)

for /f "delims=" %%f in ('dir /b /o:n "%YYprojectDir%\.build-scripts\*"') do (
	set __filePath="%YYprojectDir%\.build-scripts\%%f\post_run_step.bat"
	if exist "!__filePath!" (
		echo Build Script Manager: Executing: "!__filePath!"
		start /B /wait cmd /C "!__filePath!"
	)
)