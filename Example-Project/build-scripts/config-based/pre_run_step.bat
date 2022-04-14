@echo off

echo Current Config is %YYconfig%

if "%YYconfig%" EQU "Test Config" (
	echo We're in Test config mode! Huzzah!
)