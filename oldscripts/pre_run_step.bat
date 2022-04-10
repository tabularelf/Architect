@echo off
echo:
echo Build Script Manager - v1.0.0: By @TabularElf - https://tabelf.link/
echo:

REM Main Loop
REM We need to ensure that the directories DO exist before executing anything!
REM This portion is for first time setup...
SETLOCAL ENABLEDELAYEDEXPANSION

if not exist "%YYprojectDir%\.build-scripts\" (
	echo Build Script Manager: Warning! build-scripts directory does not exist... Creating...
	mkdir "%YYprojectDir%\.build-scripts"
)


REM Run all pre-build scripts!

REM Run the .run.bat versions first!
echo Build Script Manager: Running pre-build run scripts in order:
for %%f in ("%~DP0.pre-build\*.run.bat") do (
	echo Build Script Manager: Executing: %%~nxf.
	start /B /wait cmd /C "%%f"
)

for /f "delims=" %%f in ('dir /b /o:n "%YYprojectDir%\.build-scripts\*"') do (
	set __filePath="%YYprojectDir%\.build-scripts\%%f\pre_run_step.bat"
	if exist "!__filePath!" (
		echo Build Script Manager: Executing: "!__filePath!"
		start /B /wait cmd /C "!__filePath!"
	)
)

REM Run the .build.bat versions!
echo Build Script Manager: Running pre-build build scripts in order:
for %%f in ("%~DP0.pre-build\*.build.bat") do (
	echo Build Script Manager: Executing: %%~nxf.
	start /B /wait cmd /C "%%f"
)

for /f "delims=" %%f in ('dir /b /o:n "%YYprojectDir%\.build-scripts\*"') do (
	set __filePath="%YYprojectDir%\.build-scripts\%%f\pre_build_step.bat"
	if exist "!__filePath!" (
		echo Build Script Manager: Executing: "!__filePath!"
		start /B /wait cmd /C "!__filePath!"
	)
)