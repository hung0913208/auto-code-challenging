#!/bin/bash

ROOT="$(git rev-parse --show-toplevel)"

source $ROOT/Tests/Pipeline/Libraries/Logcat.sh
source $ROOT/Tests/Pipeline/Libraries/Languages.sh

CURRENT="$(pwd)"
SCRIPT="$(basename "$0")"

if [ -d $ROOT/Tests/Hackerrank ]; then
	source $ROOT/Tools/Utilities/hackerrank.sh

	for PLAYLIST in $(ls -1c $ROOT/Tests/Hackerrank); do
		for CHALLENGE in $(ls -1c $ROOT/Tests/Hackerrank/$PLAYLIST); do
			info "Verify test cases of $PLAYLIST/$CHALLENGE:"

			for TEST in $(ls -1c $ROOT/Tests/Hackerrank/$PLAYLIST/$CHALLENGE); do
				if ! run $ROOT/Tests/Hackerrank/$PLAYLIST/$CHALLENGE/$TEST $(language $TEST) $PLAYLIST $CHALLENGE; then
					error "fail test case Hackerrank/$PLAYLIST/$CHALLENGE/$TEST"
				elif ! submit $ROOT/Tests/Hackerrank/$PLAYLIST/$CHALLENGE/$TEST $(language $TEST) $PLAYLIST $CHALLENGE; then
					error "fail test case Hackerrank/$PLAYLIST/$CHALLENGE/$TEST"
				fi
			done
		done
	done
fi

