#!/bin/bash

function language() {
	FILENAME="$(basename $1)"
	EXTENSION="${FILENAME##*.}"

	if [ "$EXTENSION" = "py3" ]; then
		echo "python3"
	elif [ "$EXTENSION" = "py2" ]; then
		echo "python"
	elif [ "$EXTENSION" = "cc" ]; then
		echo "cpp14"
	elif [ "$EXTENSION" = "cs" ]; then
		echo "csharp"
	elif [ "$EXTENSION" = "swift" ]; then
		echo "swift"
	else
		exit -1
	fi
}
