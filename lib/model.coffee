inflect = require 'inflect'

indexes = require './indexes'
fields = require './fields'


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
        fields: {},
        primaryKey: null
        indexes: []
    }
    
    for name, property of modelClass
        if property instanceof fields.Field
            property.setup(name)
            metadata.fields[name] = property
            metadata.fieldNames.push(name)
        
        if property instanceof indexes.Index
            metadata.indexes.push(property)
    
    modelClass.__metadata = metadata
    
    for index in metadata.indexes
        index.setup(modelClass)


exports.Model = Model