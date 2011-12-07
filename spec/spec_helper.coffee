clay = require '../lib/clay'

global['clay'] = clay

global['log'] = console.log

beforeEach ->
	@addMatchers({
		toBeInstanceOf: (expected) ->
			if @actual instanceof expected
				return true
			
			throw "Expected #{@actual} to be instance of #{expected.name}."
		
		toBeEmpty: ->
			return @actual.length == 0;
		
		toContainExactly: (expectedValues...) ->
			if @actual.length != expectedValues.length
				return false
			
			for value in expectedValues
				if value not in @actual
					return false
			
			return true
		
		toHaveKey: (expectedKey) ->
			keys = []
			keys.push k for k, v of @actual
			
			@message = ->
				return "Expected to find key '#{expectedKey}' in Object{#{keys.join(', ')}}."

			return expectedKey in keys
				
	})
