Model = require('../../lib/model').Model
relations = require('../../lib/relations')
fields = require('../../lib/fields')

class TestModel2 extends Model
    constructor: ->
    

class TestModel extends Model
    constructor: ->

describe 'relations.HasMany', ->
    describe '#constructor', ->
        it 'should accept a model', ->
            rel = new relations.HasMany(TestModel)

            expect(rel).toHaveKey('childModel')
            expect(rel.childModel).toEqual(TestModel)

        it 'should throw an error when the first argument is not a Model', ->
            testShouldThrow = ->
                rel = new relations.HasMany('DefinitelyNotAModel!')
            
            expect(testShouldThrow).toThrow('HasMany requires a subclass of Model.')
    
    describe '#installFields', ->
        it 'should add the fields required to the parent model', ->
            rel = new relations.HasMany(TestModel)

            relFields = rel.installFields(TestModel2)

            expect(TestModel.metadata().fieldNames).toContain('test_model2_id');
            
            fkField = TestModel.metadata().fields.test_model2_id
            expect(fkField).toBeInstanceOf(fields.ForeignKeyField)
            expect(fkField.name).toEqual('test_model2_id')

