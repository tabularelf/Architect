#!/bin/bash

# ===Architect===

# Paths are being cleared for some reason on MacOS, so we're going to manually inject neko into it.
if [[ "$OSTYPE" == "darwin"* ]]; then
	export PATH=$PATH:/usr/local/opt/neko/bin

fi

pushd "$YYprojectDir"
neko ./architect.n -pre -package
popd

# ===Architect===

