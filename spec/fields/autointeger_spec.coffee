fields = require('../../lib/fields')


describe 'AutoIntegerField', ->
    it 'should extend IntegerField', ->
        auto = new fields.AutoIntegerField()

        expect(auto).toBeInstanceOf(fields.IntegerField)
        expect(auto).not.toBeInstanceOf(fields.CharField)
    
    it 'should default name to "id"', ->
        auto = new fields.AutoIntegerField()

        expect(auto.name).toEqual('id')
