@echo off

REM Main Loop
REM In case the post-build folder was deleted for some reason, we don't want to continue running this so exit!
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

for /d %%f in ("%~DP0.build-scripts\*") do (
	if exist "%%f\post_build_step.bat" (
		echo Build Script Manager: Executing:%%f\pre_build_step.bat 
		start /B /wait cmd /C "%%f\post_build_step.bat"
	)
)

REM Run the .run.bat versions now!
echo Build Script Manager: Running post-build run scripts...
for %%f in ("%~DP0.post-build\*.run.bat") do (
	echo Build Script Manager: Executing: %%~nxf.
	start /B /wait cmd /C "%%f"
)

for /d %%f in ("%~DP0.build-scripts\*") do (
	if exist "%%f\post_run_step.bat" (
		echo Build Script Manager: Executing:%%f\post_run_step.bat 
		start /B /wait cmd /C "%%f\post_run_step.bat"
	)
)