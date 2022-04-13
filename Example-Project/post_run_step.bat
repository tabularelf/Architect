@echo off

rem ===Architect===

pushd "%YYprojectDir%"
start /B /wait "" architect.exe -post -run
popd

rem ===Architect===

