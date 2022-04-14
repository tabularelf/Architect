#!/bin/bash

echo Current config is $YYconfig

if [[ "$YYconfig" == "Test Config" ]]; then 
	echo "We're in Test config mode! Huzzah!"
fi