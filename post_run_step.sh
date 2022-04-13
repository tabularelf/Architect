#!/bin/bash

# ===Architect===

# Paths are being cleared for some reason so we're going to manually inject it.
if [[ "$OSTYPE" == "darwin"* ]]; then
export PATH=$PATH:/usr/local/opt/neko/bin

pushd "$YYprojectDir"
neko ./architect.n -post -run
popd

# ===Architect===

