Model = require('../model').Model

class Relation
    # stub


class HasMany extends Relation
    constructor: (@model) ->
        if not @model.metadata?()
            throw {
                name: 'Error',
                message: 'HasMany requires a subclass of Model.'
            }


exports.HasMany = HasMany        
