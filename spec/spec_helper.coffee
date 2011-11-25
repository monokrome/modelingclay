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
		
		toContainKey: (expectedKey) ->
			keys = []
			keys.push k for k, v of @actual
			
			@message = ->
				return "Expected to find key '#{expectedKey}' in Object{#{keys.join(', ')}}."

			return expectedKey in keys
				
	})
