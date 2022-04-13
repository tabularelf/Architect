@echo off

rem ===Architect===

pushd "%YYprojectDir%"
start /B /wait "" architect.exe -pre -package
popd

rem ===Architect===

