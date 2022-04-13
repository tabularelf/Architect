@echo off
rem Settings. Please modify these at your own leisure.
set NumOfInsts=2
set executeInDebug=0

rem Main Execution
if %YYdebug% EQU True (
	echo Multi-Client: Warning - This doesn't fully support debug mode. There is a workaround included in the script but it may not work.
	if %executeInDebug% EQU 0 (
		echo Multi-Client: Workaround not enabled... Exiting safely...
		exit 0
	) else (
		echo Multi-Client: executeInDebug is set to 1, will attempt workaround...
		set /A NumOfInsts=%NumOfInsts%+4
	)
)

echo Multi-Client: Running instances %NumOfInsts%
for /l %%x in (1, 1, %NumOfInsts%) do (
	start /b cmd /C %YYruntimeLocation%\Windows\runner.exe -game "%YYoutputFolder%\%YYprojectName%.win"
)

echo Multi-Client: This will exit with a exitCode of 1. Igor will "fail". This is intentional.
exit 1