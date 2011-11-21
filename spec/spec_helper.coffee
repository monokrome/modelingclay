model = require '../lib/model'

global['model'] = model

global['log'] = console.log

beforeEach ->
	@addMatchers({
		toBeInstanceOf: (expected) ->
			return @actual instanceof expected
		
		toBeEmpty: ->
			return @actual.length == 0;
		
		toContainExactly: (expectedValues...) ->
			if @actual.length != expectedValues.length
				return false
			
			for value in expectedValues
				if value not in @actual
					return false
			
			return true
	})