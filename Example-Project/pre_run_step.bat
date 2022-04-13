@echo off

rem ===Architect===

pushd "%YYprojectDir%"
start /B /wait  "" architect.exe -pre -run
popd

rem ===Architect===

