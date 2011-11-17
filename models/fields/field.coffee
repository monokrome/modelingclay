inflect = require 'inflect'

class Field
	constructor: (opts...) ->
		@name = null
		@options = opts
	
	setup: (name) =>
		@name = inflect.underscore(name)
	
	validate: (value) =>
		return true

exports.Field = Field