@echo off

rem ===Architect===

pushd "%YYprojectDir%"
start /B /wait "" architect.exe -post -package
popd

rem ===Architect===

