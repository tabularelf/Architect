# Architect v0.5.0
 A mini set of build scripts that allow multiple build script execution in GameMaker.

## Why does this exist?
A bit of back peddling. GameMaker has recently introduced a way for batch/shell files to be executed while the project is being compiled, in 2 separate stages.
With it running for either run or package. Or build for both. The problem? GameMaker doesn't have a way of executing more than one set of build scripts. This isn't really a problem unless you want to use someone elses build scripts, right? 

Recently, YoYoGames has started taking advantage of build scripts for some of their extensions. (i.e. steamworks extension). And other libraries (like upcoming @jujuAdams dynamo) also require build scripts to properly function.

The solution? These build scripts provided by me, allow the possibility of executing multiple build scripts. Without having to merge existing build scripts together.

## That's great! How do I set it up?
It's relatively straight forward.

1. Download the latest version from Releases and drag the contents of the zip to your project directory. (That being where your *.ypp is located)
2. Create `.build-scripts` (or build your game once).
3. Create a new folder within `.build-scripts` with whatever name you'd like, for each and every build scripts from a library/extension that you need. i.e. `steamworks` for steamworks build scripts.
4. Drag your existing (or future) build scripts into said folder. Repeat from step 3. until done.
5. Run your game.

Your build scripts will execute in alphabetical order, one script at a time.

## What if I want to run a set of scripts BEFORE everything else?
The best way to guaranteed priority execution, is to rename your folder to have a `.` at the start.
Alternatively, you may make a `.pre-build` or `.post-build` in your project directory and use the following name scheme and add build scripts as such.

`pre_run_step.bat/pre_build_step.bat/pre_package_step.bat` -> `script_name.run.bat/script_name.build.bat/script_name.package.bat` -> `.pre-build\script_name.ext`
`post_run_step.bat/post_build_step.bat/post_package_step.bat `-> `script_name.run.bat/script_name.build.bat/script_name.package.bat` -> `.post-build\script_name.ext` 

## Is MacOSX/Linux supported?
As of yet no, but I am working towards adding support to both platforms.
