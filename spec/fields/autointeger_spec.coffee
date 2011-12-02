fields = require('../../lib/fields')


describe 'AutoIntegerField', ->
    it 'should extend IntegerField', ->
        auto = new fields.AutoIntegerField()

        expect(auto).toBeInstanceOf(fields.IntegerField)
    
    it 'should default name to "id"', ->
        auto = new fields.AutoIntegerField()

        expect(auto.name).toEqual('id')
