Model = require('../../lib/model').Model
relations = require('../../lib/relations')

class TestModel extends Model
    constructor: ->

describe 'relations.HasMany', ->
    describe '#constructor', ->
        it 'should accept a model', ->
            rel = new relations.HasMany(TestModel)

            expect(rel).toContainKey('model')
            expect(rel.model).toEqual(TestModel)

        it 'should throw an error when the first argument is not a Model', ->
            testShouldThrow = ->
                rel = new relations.HasMany('DefinitelyNotAModel!')
            
            expect(testShouldThrow).toThrow('HasMany requires a subclass of Model.')
        
        
