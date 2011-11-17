class AdapterInterface
	constructor: (args) ->
		
	connect: (@host, @username, @password, @database) ->
		throw {
			name: 'Error',
			message: 'Not Implemented.'
		}
	
	disconnect: ->
		throw {
			name: 'Error',
			message: 'Not Implemented.'
		}
	
	query: (query_string, params, callback) ->
		throw {
			name: 'Error',
			message: 'Not Implemented.'
		}
	

exports.AdapterInterface = AdapterInterface
