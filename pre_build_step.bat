@echo off

rem ===Architect===

pushd "%YYprojectDir%"
start /B /wait "" architect.exe -pre -build
popd

rem ===Architect===

