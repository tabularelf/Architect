@echo off

rem ===Architect===

pushd "%YYprojectDir%"
start /B /wait "" architect.exe -post -build
popd

rem ===Architect===

