#!/bin/bash

COOKIES=$HRANK_UUID
TOKEN=$HRANK_TOKEN

ROOT=$(git rev-parse --show-toplevel)

function get() {
	CHALLENGE=$2
	TYPE=$3
	MODE=$1
	CODE=1

	if [[ ${#COOKIES} -ne 0 ]]; then
		GET_TEMPFILE=$(mktemp /tmp/hackerrank_get.XXXXXX)

		cat > $GET_TEMPFILE << EOF
curl -sS 'https://www.hackerrank.com/rest/contests/master/challenges/$CHALLENGE/$TYPE/$MODE' 		\
--request GET 												\
-H 'Accept: application/json' 										\
-H 'Content-Type: application/json' 									\
-H 'Cookie: $COOKIES' 											\
-H 'X-CSRF-Token: $TOKEN'
EOF
		while [[ $CODE -eq 1 ]]; do
			bash $GET_TEMPFILE | python -c """
from json import load
from sys import stdin, exit

try:
	metadata = load(stdin)['model']

	if 'compilemessage' in metadata and len(metadata['compilemessage']) > 0:
		print('compile error: %s' % metadata['compilemessage'])
	elif metadata['status'] in ['Accepted', 1]:
		error = metadata.get('stderr')
		inputs = metadata.get('stdin')
		outputs = metadata.get('stdout')
		expects = metadata.get('testcase_status')
		passed = True

		if 'status_string' in metadata:
			status = metadata['status_string']['testcase_status']
		else:
			status = metadata['testcase_status']

		if 'stdout_debug' in metadata:
			debugs = metadata['stdout_debug']
		else:
			debugs = None
	
		for idx, val in enumerate(status):
			if val == 0:
				print('Test case {} fail'.format(idx))
				print('')

				if inputs:
					print('Input:')
					print('{}'.format(inputs[idx]))
					print('----------------------------')
					print('')

				if outputs:
					print('Your output:')
					print('{}'.format(outputs[idx]))
					print('----------------------------')
					print('')
				
				if expects:	
					print('We expect it should be:')
					print('----------------------------')
					print('{}'.format(expects[idx]))
					print('')

				if debugs and len(debugs[idx]) > 0:
					print('Here is your debug log:')
					print('----------------------------')
					print('{}'.format(debugs[idx]))
					print('')

				passed = False
		else:
			if passed is False:
				exit(2)
			else:
				exit(0)
	else:
		exit(1)
except Exception:
	exit(2)
"""
			CODE=$?

			if [[ $CODE -eq 1 ]]; then
				sleep 1
			else
				break
			fi
		done
		rm -fr $RUN_TEMPFILE
	fi

	return $CODE
}
function run() {
	LANG=$2
	PLAYLIST=$3

	if [[ ${#COOKIES} -ne 0 ]]; then
		RUN_TEMPFILE=$(mktemp /tmp/hackerrank_run.XXXXXX)

		cat > $RUN_TEMPFILE << EOF
curl -sS 'https://www.hackerrank.com/rest/contests/master/challenges/$4/compile_tests'	\
	--request POST 									\
	-H 'Content-Type: application/json' 						\
	-H 'Cookie: $COOKIES'								\
	-H 'X-CSRF-Token: $TOKEN'							\
	-H 'Accept: application/json' 							\
	--data-binary '{"code": "$($ROOT/Tools/Utilities/source_code_converting.py $1)", "language":"$LANG","contest_slug":"master","playlist_slug":"$PLAYLIST"}'
EOF

		MODE=$(bash $RUN_TEMPFILE | python -c """
from json import load
from sys import stdin, exit

try:
	print(load(stdin)['model']['id'])
except Exception:
	exit(-1)
""")
		CODE=$?
		rm -fr $RUN_TEMPFILE

		if [[ $CODE -ne 0 ]]; then
			return $CODE
		elif [[ ${#MODE} -gt 0 ]]; then
			get $MODE $4 'compile_tests'
			return $?
		else
			return -2
		fi
	else
		return -1
	fi
}

function submit() {
	LANG=$2
	PLAYLIST=$3

	if [[ ${#COOKIES} -ne 0 ]]; then
		SUBMIT_TEMPFILE=$(mktemp /tmp/hackerrank_submit.XXXXXX)

		cat > $SUBMIT_TEMPFILE << EOF
curl -sS 'https://www.hackerrank.com/rest/contests/master/challenges/$4/submissions' 	\
	--request POST 									\
	-H 'Content-Type: application/json' 						\
	-H 'Accept: application/json' 							\
	-H 'Cookie: $COOKIES' 								\
	-H 'X-CSRF-Token: $TOKEN'							\
	--data-binary '{"code": "$($ROOT/Tools/Utilities/source_code_converting.py $1)", "language":"$LANG","contest_slug":"master","playlist_slug":"$PLAYLIST"}'
EOF

		MODE=$(bash $SUBMIT_TEMPFILE | python -c """
from json import load
from sys import stdin, exit

try:
	print(load(stdin)['model']['id'])
except Exception:
	exit(-1)
""")
		CODE=$?
		rm -fr $SUBMIT_TEMPFILE
		
		if [[ $CODE -ne 0 ]]; then	
			return $CODE
		else
			get $MODE $4 'submissions'
			return $?
		fi
	else
		return -1
	fi
}

