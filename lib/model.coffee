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
        indexes: [],
        indexNames: []
    }
    
    for name, property of modelClass
        if property instanceof fields.Field
            setupField(metadata, property, name)
        
        if property instanceof indexes.Index
            setupIndex(metadata, property, name)
    
    modelClass.__metadata = metadata

    if metadata.primaryKey is null
        metadata.primaryKey = setupField(metadata, new fields.AutoIntegerField(), 'id')
    
    for index in metadata.indexes
        index.validate(modelClass)

setupField = (metadata, field, name) ->
    field.setup(name)
    metadata.fields[name] = field
    metadata.fieldNames.push(name)

    return field

setupIndex = (metadata, index, nameFromModel) ->
    index.setup(nameFromModel)
    metadata.indexes.push(index)
    metadata.indexNames.push(nameFromModel)

    return index


exports.Model = Model
