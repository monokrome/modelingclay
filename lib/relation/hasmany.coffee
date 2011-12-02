Model = require('../model').Model
fields = require('../fields')

class Relation
    # stub


class HasMany extends Relation
    constructor: (@childModel) ->
        if not @childModel.metadata?()
            throw {
                name: 'Error',
                message: 'HasMany requires a subclass of Model.'
            }
    
    installFields: (@parentModel) ->
        fkField = new fields.ForeignKeyField(@parentModel)
        fkFieldName = "#{@parentModel.metadata().tableName}_id"
        @childModel.metadata().setupField(fkField, fkFieldName)

        


exports.HasMany = HasMany        
