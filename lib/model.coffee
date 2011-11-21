inflect = require 'inflect'

QueryManager = require('./querymanager').QueryManager

Field = require('./fields/field').Field
CharField = require('./fields/char').CharField


__models = {}

class Model
	constructor: (args) ->
		# pass

tableize = (string) ->
	return inflect.pluralize(inflect.underscore(string))

exports.define = (modelClass) ->
	modelName = modelClass.name
	
	metadata = {
		name: modelName,
		tableName: tableize(modelName)
		fields: {}
	}
	
	for name, field of modelClass
		if field instanceof Field
			field.setup(name)
			metadata.fields[name] = field
	
	# log metadata
	
	modelClass.metadata = metadata
	modelClass.objects = new QueryManager(modelClass)


exports.Model = Model
exports.QueryManager = QueryManager
exports.CharField = CharField