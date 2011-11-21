AdapterInterface = require('../../models/adapters/interface').AdapterInterface

adapter = new AdapterInterface()

describe 'AdapterInterface', ->
	beforeEach = =>
	
	it 'defines connect', =>
		test = ->
			adapter.connect('host', 'username', 'password', 'name')
		
		expect(test).toThrow('Not Implemented.')
	
	it 'defines query', =>
		test = ->
			adapter.query('query string', [], )

		expect(test).toThrow('Not Implemented.')