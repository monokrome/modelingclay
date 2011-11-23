inflect = require 'inflect'

QueryManager = require('./querymanager').QueryManager

Field = require('./fields/field').Field
CharField = require('./fields/char').CharField


__models = {}

class Model
    constructor: (args) ->
        # I wish CoffeeScript had the capability to get all subclasses of Model so something
        # like this isn't required.
        this.constructor.metadata()
    
    @metadata: ->
        if not @__metadata
            define(this)
        
        return @__metadata

tableize = (string) ->
    return inflect.pluralize(inflect.underscore(string))

define = (modelClass) ->
    modelName = modelClass.name
    
    metadata = {
        name: modelName,
        tableName: tableize(modelName)
        fieldNames: [],
        fields: {}
    }
    
    for name, field of modelClass
        if field instanceof Field
            field.setup(name)
            metadata.fields[name] = field
            metadata.fieldNames.push(name)
    
    modelClass.__metadata = metadata
    modelClass.objects = new QueryManager(modelClass)


exports.Model = Model
exports.QueryManager = QueryManager
exports.CharField = CharField