@echo off
echo:
echo Build Script Manager - v1.0.0: By @TabularElf - https://tabelf.link/
echo:

REM Main Loop
REM We need to ensure that the directories DO exist before executing anything!
REM This portion is for first time setup...
if not exist "%YYprojectDir%\.build-scripts\" (
	echo Build Script Manager: Warning! build-scripts directory does not exist... Creating...
	mkdir "%YYprojectDir%\build-scripts"
)

REM Run all pre-build scripts!

REM Run the .run.bat versions first!
echo Build Script Manager: Running pre-build package scripts in order:
for %%f in ("%~DP0.pre-build\*.package.bat") do (
	echo Build Script Manager: Executing: %%~nxf.
	start /B cmd /C "%%f"
)

for /d %%f in ("%~DP0.build-scripts\*") do (
	if exist "%%f\pre_package_step.bat" (
		echo Build Script Manager: Executing:%%f\pre_package_step.bat 
		start /B /wait cmd /C "%%f\pre_package_step.bat"
	)
)

REM Run the .build.bat versions!
echo Build Script Manager: Running pre-build build scripts in order:
for %%f in ("%~DP0.pre-build\*.build.bat") do (
	echo Build Script Manager: Executing: %%~nxf.
	start /B cmd /C "%%f"
)

for /d %%f in ("%~DP0.build-scripts\*") do (
	if exist "%%f\pre_build_step.bat" (
		echo Build Script Manager: Executing:%%f\pre_build_step.bat 
		start /B /wait cmd /C "%%f\pre_build_step.bat"
	)
)