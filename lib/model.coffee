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
            @__metadata = new ModelMetadata(this)
            @__metadata.setup()
        
        return @__metadata


tableize = (string) ->
    return inflect.underscore(string)


class ModelMetadata
    constructor: (@modelClass) ->
        @name = @modelClass.name
        @tableName = tableize(@name)
        @fieldNames = []
        @fields = {}
        @primaryKey = null
        @indexes = []
        @indexNames = []
        @relations = []

    setup: ->
        for name, property of @modelClass
            if property instanceof fields.Field
                @setupField(property, name)
            
            if property instanceof indexes.Index
                @setupIndex(property, name)
            
        if @primaryKey is null
            @setupField(new fields.AutoIntegerField(), 'id')
        
        for index in @indexes
            index.validate(this)
    
    setupField: (field, nameFromModel) ->
        field.setup(nameFromModel)

        @fields[nameFromModel] = field
        @fieldNames.push(nameFromModel)

        if field instanceof fields.AutoIntegerField
            @primaryKey = field
    
    setupIndex: (index, nameFromModel) ->
        index.setup(nameFromModel)

        @indexes.push(index)
        @indexNames.push(nameFromModel)
    
    installRelation: (relation) ->
        @relations.push(relation)

        relation.installFields(@modelClass)



exports.Model = Model
exports.ModelMetadata = ModelMetadata
