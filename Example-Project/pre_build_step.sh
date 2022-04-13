#!/bin/bash

# ===Architect===

# Paths are being cleared for some reason on MacOS, for every single build script!!!
# So we're going to manually give back paths.
# In the event that fails, we'll inject neko in manually. Please ensure that you have neko in your PATH.
if [[ "$OSTYPE" == "darwin"* ]]; then
	source ~/.bash_profile
	if [[ $? ]]; then
		# We're going to try another.
		source ~/.bashrc
 	fi
	if [[ $? ]]; then
	# We're exposing neko manually. Most users will have it in the default path.
		export PATH=$PATH:/usr/local/opt/neko/bin
	fi
fi

pushd "$YYprojectDir"
neko ./architect.n -pre -build
if [[ $? != 0 ]]; then
	exit $?
fi
popd

# ===Architect===

