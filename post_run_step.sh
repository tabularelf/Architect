#!/bin/bash
echo FIND ME

if [ ! -d "$YYprojectDir/.build-scripts" ]
then
	echo "Architect: .build-scripts doesn't exist. Creating..."
fi

echo "Architect: Executing post-build scripts."
readarray -d '' entries < <(printf '%s\0' "$YYprojectDir/.build-scripts"/* | sort -zV)
for f in "${entries[@]}"; do
	if [ -d "$f" ]; then 
		if [ -f "$f/post_build_step.sh" ]; then
			# Lets make sure that we can execute shell
			if [ ! -x "$f/post_build_step.sh" ]; then
				chmod u+x "$f/post_build_step.sh"
			fi
			$f/post_build_step.sh
		fi
	fi
done

echo "Architect: Executing post-run scripts."
readarray -d '' entries < <(printf '%s\0' "$YYprojectDir/.build-scripts"/* | sort -zV)
for f in "${entries[@]}"; do
	if [ -d "$f" ]; then 
		if [ -f "$f/post_run_step.sh" ]; then
			# Lets make sure that we can execute shell
			if [ ! -x "$f/post_run_step.sh" ]; then
				chmod u+x "$f/post_run_step.sh"
			fi
			$f/post_run_step.sh
		fi
	fi
done
