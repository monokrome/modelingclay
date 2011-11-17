model = require '../models/model'

global['model'] = model

global['log'] = console.log

beforeEach ->
	@addMatchers({
		toBeInstanceOf: (expected) ->
			return @actual instanceof expected
		
		toBeEmpty: ->
			return @actual.length == 0;
	})