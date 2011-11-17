#!/usr/bin/env coffee

exec = require('child_process').exec

run_all_specs = ->
	exec 'jasmine-node --coffee spec', (error, stdout, stderr) ->
		console.log('====================================================================================')
		console.log(stdout)
		console.log(stderr)

run_all_specs()

require('sentry').watch './**/*.coffee', run_all_specs