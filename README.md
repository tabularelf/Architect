# Architect v0.5.0
 A mini set of build scripts that allow multiple build script execution in GameMaker.

## Why does this exist?
A bit of back peddling. GameMaker has recently introduced a way for batch/shell files to be executed while the project is being compiled, in 2 separate stages.
With it running for either run or package. Or build for both. The problem? GameMaker doesn't have a way of executing more than one set of build scripts. This isn't really a problem unless you want to use someone elses build scripts, right? 

Recently, YoYoGames has started taking advantage of build scripts for some of their extensions. (i.e. steamworks extension). And other libraries (like upcoming @jujuAdams dynamo) also require build scripts to properly function.

The solution? These build scripts provided by me, allow the possibility of executing multiple build scripts. Without having to merge existing build scripts together.

## That's great! How do I set it up?
It's relatively straight forward.

1. Download the latest version from Releases (architect.zip) and put into the root directory of your project.
**For MacOSX/Linux Users:** Download and install Neko VM. (https://nekovm.org/download/) (~/.bash_profile or ~/.bashrc) before using Architect!
Additional notes for **MacOSX** Users: Please add `/usr/local/opt/neko/bin` to your paths globally.
2. Run architect.exe (MacOSX/Linux type `neko architect.n` in terminal.) You may provide `-help` to see additional arguments.\
Notes: By default, Architect only creates build scripts for the respective OS. You want to provide `-forceCreate` to force Architect to create batch/shell files.
3. Architect will create a new folder called `build-scripts`. Put your build-scripts in their own respective folder. (i.e. steamworks).
4. Build/run your game.

Your build scripts will execute in alphabetical order, one script at a time.

## What if I want to run a set of scripts BEFORE everything else?
The best way to guaranteed priority execution, is to rename your folder to have a `.` at the start. 
i.e. `.RunFirst` will run first before any other build scripts.
