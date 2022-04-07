#!/bin/bash
echo FIND ME

if [ ! -d "$YYprojectDir/.build-scripts" ]
then
	echo "Architect: .build-scripts doesn't exist. Creating..."
fi

# Enable flag to allow us to search hidden folders
shopt -s dotglob

readarray -d '' entries < <(printf '%s\0' "$YYprojectDir/.build-scripts"/* | sort -zV)
for f in "${entries[@]}"; do
	echo "$f"
	if [ -d "$f" ]; then 
		if [ -f "$f/pre_run_step.sh" ]; then
			# Lets make sure that we can execute shell
			if [ ! -x "$f/pre_run_step.sh" ]; then
				chmod u+x "$f/pre_run_step.sh"
			fi
			$f/pre_run_step.sh
		fi
	fi
done

echo DONE

read -p "Press [Enter] key to start backup..."
