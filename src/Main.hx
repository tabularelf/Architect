import sys.FileSystem;
import sys.io.File;

@:enum
abstract StageType(Int) {
	var Null = -1;
	var Pre = 0;
	var Post = 1;
}
@:enum
abstract BuildType(Int) {
	var Null = -1;
	var Run = 0;
	var Package = 1;
	var Build = 2;
}
@:enum
abstract BuildInfo(String) {
	var Credits = "Created by @TabularElf - https://tabelf.link/";
	var Version = "v0.5.0";
}

class Global {
	public static var verbose = false;
	public static var ignoreFiles = false;
	public static var forceReplace = false;
}

class Main {
	static function getEntries(dir:String, entries:Null<Array<String>> = null, inDir:Null<String> = null) {
		if (entries == null) entries = new Array();
		if (inDir == null) inDir = dir;
		for(file in sys.FileSystem.readDirectory(dir)) {
			var path = haxe.io.Path.join([dir, file]);
			if (sys.FileSystem.isDirectory(path)) {
				entries.push(path);
			} 
		}
		return entries;
	}	
	
	static function __archTrace(str:String) {
		Sys.println("Architect: " + str);
	}
	
	static function __archCreateExec(path:String, file:String, type:String) {
			var _fileExists = sys.FileSystem.exists(path + "/" + file);
			if ((_fileExists == true) && (Global.forceReplace != true)) {
				if (Global.ignoreFiles == false) {
					var _contents = sys.io.File.getContent(path + "/" + file);
					__archTrace(file + " exists! Injecting...");
					if (StringTools.contains(_contents, "===Architect===")) {
						__archTrace(file + " contains Architect! Please clear out the batch/shell files and run again.");
						Sys.exit(1);
					}
					
					if (StringTools.contains(_contents, "#!/bin/bash")) {
						if (Global.verbose) __archTrace("Stripping all traces of #!/bin/bash");
						_contents = StringTools.replace(_contents, "#!/bin/bash", "");
					}
					sys.io.File.saveContent(path + "/" + file, type + _contents);
				} else {
					if (Global.verbose) __archTrace(file + " exists! Skipping...");
				}
			} else {
				if ((_fileExists == true) && (Global.forceReplace == true)) {
					__archTrace(file + " exists! forceReplace is enabled... Replacing...");	
				} else if (_fileExists == false) {
					__archTrace(file + " doesn't exist! Creating...");
				}
				sys.io.File.saveContent(path + "/" + file, type);
				if ((Sys.systemName() != "Windows") && StringTools.contains(file, ".sh")) Sys.command("chmod u+x " + path + "/" + file);
			}
	}
	
	static function __help() {
		__archTrace(BuildInfo.Version + " - " + BuildInfo.Credits);
		Sys.println("===Help===");
		Sys.println("Repo: https://github.com/tabularelf/Architect\n");
		Sys.println("Arguments:\n-help | What you're seeing right now.\n-ignore | Tells Architect to ignore existing shell/batch files.\n-verbose -v | Gives extra information in the output log.\n-forceReplace | Forces Architect to replace existing batch/shell scripts.\n-forceCreate | Forces Architect to create batch/shell scripts.\n\n===Intended to be used by Architect only!===\n-pre -post | Determines the start/end of the compiling.\n-run -package -build | Determines what type of script to run between each stage in compiling.");
	}
	
	static function main() {
		// Start	
		var stageType = StageType.Null;
		var buildType = BuildType.Null;
		var buildTypeStr = "";
		var stageTypeStr = "";
		var enforceShells = false;

		
		var args = Sys.args();
		var _i = 0;
		while(_i < args.length) {
				switch(args[_i].toLowerCase()) {
					case "-v": 
						Global.verbose = true;
					case "-verbose":
						Global.verbose = true;
				
					// Get StageType
					case "-pre":
						stageType = StageType.Pre;
						stageTypeStr = args[_i].substring(1);
					
					case "-post":
						stageType = StageType.Post;
						stageTypeStr = args[_i].substring(1);
						
					// Get BuildType
					case "-run":
						buildType = BuildType.Run;
						buildTypeStr = args[_i].substring(1);
					case "-package":
						buildType = BuildType.Package;
						buildTypeStr = args[_i].substring(1);
					case "-build":
						buildType = BuildType.Build;
						buildTypeStr = args[_i].substring(1);
					case "-forcecreate":
						enforceShells = true;
					case "-help":
						__help();
						Sys.exit(0);
					case "-ignore":
						Global.ignoreFiles = true;
					case "-forcereplace": 
						Global.forceReplace = true;
				}
				++_i;
			}
		
		if ((stageType == StageType.Null) && (buildType == BuildType.Null)) {
			__archTrace(BuildInfo.Version + " - " + BuildInfo.Credits);
			// First time setup
			__archTrace("This a first time setup initated.\nPlease wait...");
			
			var _path = Sys.getCwd();
			
			/*
				If you're reading this commment. Then congrats. You're about to witness the spaghetti zone.
				Yes, I know it's long and awful. But, this is honestly a lot easier to read and find errors in than other methods... At least, according to my preferred code editor, Notepad++.
				So you're going to have to deal with it! (I might change it over later but dunno.)
			*/
			
			var _MacOSSafetyInjection:String = "# Paths are being cleared for some reason on MacOS, for every single build script!!!\n# So we're going to manually give back paths.\n# In the event that fails, we'll inject neko in manually. Please ensure that you have neko in your PATH.\n";
			_MacOSSafetyInjection += "if [[ \"$OSTYPE\" == \"darwin\"* ]]; then\n";
			_MacOSSafetyInjection += "	source ~/.bash_profile\n";
			_MacOSSafetyInjection += "	if [[ $? ]]; then\n";
			_MacOSSafetyInjection += "		# We're going to try another.\n";
			_MacOSSafetyInjection += "		source ~/.bashrc\n";
			_MacOSSafetyInjection += " 	fi\n";
			_MacOSSafetyInjection += "	if [[ $? ]]; then\n";
			_MacOSSafetyInjection += "	# We're exposing neko manually. Most users will have it in the default path.\n";
			_MacOSSafetyInjection += "		export PATH=$PATH:/usr/local/opt/neko/bin\n";
			_MacOSSafetyInjection += "	fi\n";
			_MacOSSafetyInjection += "fi\n\n";
			
			var _shellErrorDetection:String = "if [[ $? != 0 ]]; then\n";
			_shellErrorDetection += "	exit $?\n";
			_shellErrorDetection += "fi\n";
			
			var _batchErrorDetection:String = "if %ERRORLEVEL% NEQ 0 (\n";
			_batchErrorDetection += "	exit %ERRORLEVEL%\n";
			_batchErrorDetection += ")\n";
			
			// Windows
			var _preRunBat:String = "@echo off\n\n";
			_preRunBat += "rem ===Architect===\n\n";
			_preRunBat += "pushd \"%YYprojectDir%\"\n";
			_preRunBat += "start /B /wait  \"\" architect.exe -pre -run\n";
			_preRunBat += _batchErrorDetection;
			_preRunBat += "popd\n\n";
			_preRunBat += "rem ===Architect===\n\n";
			
			var _preBuildBat:String = "@echo off\n\n";
			_preBuildBat += "rem ===Architect===\n\n";
			_preBuildBat += "pushd \"%YYprojectDir%\"\n";
			_preBuildBat += "start /B /wait \"\" architect.exe -pre -build\n";
			_preBuildBat += _batchErrorDetection;
			_preBuildBat += "popd\n\n";
			_preBuildBat += "rem ===Architect===\n\n";
			
			var _prePackageBat:String = "@echo off\n\n";
			_prePackageBat += "rem ===Architect===\n\n";
			_prePackageBat += "pushd \"%YYprojectDir%\"\n";
			_prePackageBat += "start /B /wait \"\" architect.exe -pre -package\n";
			_prePackageBat += _batchErrorDetection;
			_prePackageBat += "popd\n\n";
			_prePackageBat += "rem ===Architect===\n\n";
			
			var _postRunBat:String = "@echo off\n\n";
			_postRunBat += "rem ===Architect===\n\n";
			_postRunBat += "pushd \"%YYprojectDir%\"\n";
			_postRunBat += "start /B /wait \"\" architect.exe -post -run\n";
			_postRunBat += _batchErrorDetection;
			_postRunBat += "popd\n\n";
			_postRunBat += "rem ===Architect===\n\n";
			
			var _postBuildBat:String = "@echo off\n\n";
			_postBuildBat += "rem ===Architect===\n\n";
			_postBuildBat += "pushd \"%YYprojectDir%\"\n";
			_postBuildBat += "start /B /wait \"\" architect.exe -post -build\n";
			_postBuildBat += _batchErrorDetection;
			_postBuildBat += "popd\n\n";
			_postBuildBat += "rem ===Architect===\n\n";
			
			var _postPackageBat:String = "@echo off\n\n";
			_postPackageBat += "rem ===Architect===\n\n";
			_postPackageBat += "pushd \"%YYprojectDir%\"\n";
			_postPackageBat += "start /B /wait \"\" architect.exe -post -package\n";
			_postPackageBat += _batchErrorDetection;
			_postPackageBat += "popd\n\n";
			_postPackageBat += "rem ===Architect===\n\n";
			
			// Linux/MacOS
			var _preRunShell:String = "#!/bin/bash\n\n";
			_preRunShell += "# ===Architect===\n\n";
			_preRunShell += _MacOSSafetyInjection;
			_preRunShell += "pushd \"$YYprojectDir\"\n";
			_preRunShell += "neko ./architect.n -pre -run\n";
			_preRunShell += _shellErrorDetection;
			_preRunShell += "popd\n\n";
			_preRunShell += "# ===Architect===\n\n";
			
			var _preBuildShell:String = "#!/bin/bash\n\n";
			_preBuildShell += "# ===Architect===\n\n";
			_preBuildShell += _MacOSSafetyInjection;
			_preBuildShell += "pushd \"$YYprojectDir\"\n";
			_preBuildShell += "neko ./architect.n -pre -build\n";
			_preBuildShell += _shellErrorDetection;
			_preBuildShell += "popd\n\n";
			_preBuildShell += "# ===Architect===\n\n";
			
			var _prePackageShell:String = "#!/bin/bash\n\n";
			_prePackageShell += "# ===Architect===\n\n";
			_prePackageShell += _MacOSSafetyInjection;
			_prePackageShell += "pushd \"$YYprojectDir\"\n";
			_prePackageShell += "neko ./architect.n -pre -package\n";
			_prePackageShell += _shellErrorDetection;
			_prePackageShell += "popd\n\n";
			_prePackageShell += "# ===Architect===\n\n";
			
			var _postRunShell:String = "#!/bin/bash\n\n";
			_postRunShell += "# ===Architect===\n\n";
			_postRunShell += _MacOSSafetyInjection;
			_postRunShell += "pushd \"$YYprojectDir\"\n";
			_postRunShell += "neko ./architect.n -post -run\n";
			_postRunShell += _shellErrorDetection;
			_postRunShell += "popd\n\n";
			_postRunShell += "# ===Architect===\n\n";
			
			var _postBuildShell:String = "#!/bin/bash\n\n";
			_postBuildShell += "# ===Architect===\n\n";
			_postBuildShell += _MacOSSafetyInjection;
			_postBuildShell += "pushd \"$YYprojectDir\"\n";
			_postBuildShell += "neko ./architect.n -post -build\n";
			_postBuildShell += _shellErrorDetection;
			_postBuildShell += "popd\n\n";
			_postBuildShell += "# ===Architect===\n\n";
			
			var _postPackageShell:String = "#!/bin/bash\n\n";
			_postPackageShell += "# ===Architect===\n\n";
			_postPackageShell += _MacOSSafetyInjection;
			_postPackageShell += "pushd \"$YYprojectDir\"\n";
			_postPackageShell += "neko ./architect.n -post -package\n";
			_postPackageShell += _shellErrorDetection;
			_postPackageShell += "popd\n\n";
			_postPackageShell += "# ===Architect===\n\n";
			
			// Check .build-script state
			if (!sys.FileSystem.exists(_path + "/build-scripts")) {
				__archTrace("Directory /build_scripts/ doesn't exist. Creating...");
				sys.FileSystem.createDirectory(_path + "/build-scripts");
			} else {
				__archTrace("Directory /build_scripts/ exists!");
			}
			
			// ==Windows==
			// pre run
			var _file = "pre_run_step.bat";
			var _type = _preRunBat;
			// pre build
			var _file = "pre_build_step.bat";
			var _type = _preBuildBat;
			
			// pre package
			var _file = "pre_package_step.bat";
			var _type = _prePackageBat;
			
			// ===WINDOWS POST===
			
			// ==Linux==
			
			// pre run
			var _file = "pre_run_step.sh";
			var _type = _preRunShell;
			
			// pre build
			var _file = "pre_build_step.sh";
			var _type = _preBuildShell;
			
			// pre package
			var _file = "pre_package_step.sh";
			var _type = _prePackageShell;
			
			// Batch
			if ((Sys.systemName() == "Windows") || (enforceShells == true)) {
				__archCreateExec(_path, "pre_package_step.bat", _prePackageBat);
				__archCreateExec(_path, "pre_run_step.bat", _preRunBat);
				__archCreateExec(_path, "pre_build_step.bat", _preBuildBat);
				__archCreateExec(_path, "post_package_step.bat", _postPackageBat);
				__archCreateExec(_path, "post_run_step.bat", _postRunBat);
				__archCreateExec(_path, "post_build_step.bat", _postBuildBat);
			}
			
			// Shell
			if ((Sys.systemName() != "Windows") || (enforceShells == true)) {
				__archCreateExec(_path, "pre_package_step.sh", _prePackageShell);
				__archCreateExec(_path, "pre_run_step.sh", _preRunShell);
				__archCreateExec(_path, "pre_build_step.sh", _preBuildShell);
				__archCreateExec(_path, "post_package_step.sh", _postPackageShell);
				__archCreateExec(_path, "post_run_step.sh", _postRunShell);
				__archCreateExec(_path, "post_build_step.sh", _postBuildShell);
			}
			
		} else if ((stageType == StageType.Null) || (buildType == BuildType.Null)) {
			__archTrace("Invalid arguments provided " + args.toString() + "\nValid arguments: -pre/-post -run/-package/-build -v/-verbose");
			Sys.exit(1);
		} else if ((stageType == StageType.Pre) && (buildType != BuildType.Build)) {
			__archTrace(BuildInfo.Version + " " + BuildInfo.Credits + "\nExecuting scripts...");
		}
 		
		if ((stageType != StageType.Null) && (buildType != BuildType.Null)) {
			switch(stageType) {
				case stageType.Pre:
					switch(buildType) {
						case BuildType.Run:
						__archTrace("Step: ===1/4===");
						case BuildType.Package:
						__archTrace("Step: ===1/4===");
						case BuildType.Build:
						__archTrace("Step: ===2/4===");
						default:
						__archTrace("Executed in invalid state. Exiting...");
						Sys.exit(1);
						
					}
				case stageType.Post:
					switch(buildType) {
						case BuildType.Run:
						__archTrace("Step: ===4/4===");
						case BuildType.Package:
						__archTrace("Step: ===4/4===");
						case BuildType.Build:
						__archTrace("Step: ===3/4===");
						default:
						__archTrace("Executed in invalid state. Exiting...");
						Sys.exit(1);
					}
				default:
				__archTrace("Executed in invalid state. Exiting...");
				Sys.exit(1);
			}
			
			var list = getEntries(Sys.getCwd() + "/build-scripts/");
			list.sort(function(a, b) {
				if(a > b) return -1;
				else if(a < b) return 1;
				else return 0;
			});
			
			var _fileExt:String = ".sh";
			if (Sys.systemName() == "Windows") {
				_fileExt = ".bat";
			}
			
			var _fileName:String = stageTypeStr + "_" + buildTypeStr + "_step" + _fileExt;
			while (list.length > 0) {
				var _filePath = list.pop();
				if (Global.verbose) __archTrace("Checking directory: " + _filePath);
				if (sys.FileSystem.exists(_filePath + "/" + _fileName)) {
					if (Global.verbose) __archTrace("File \"" + _fileName + "\" exists!");
					__archTrace("Running file at: " + _filePath + "/" + _fileName);
					var _exitCode = Sys.command("\"" + _filePath + "/" + _fileName + "\"");
					if (_exitCode != 0) {
						__archTrace("An error has occured. Exit status of " + Std.string(_exitCode) + " from " + _filePath + "/" + _fileName + ".\nPlease read the output log to verify that there's no issues.\nExiting...");
						Sys.exit(1);
					}
				}
			}
		}
	}
}