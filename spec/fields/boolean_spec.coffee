fields = require('../../lib/fields')


describe 'BooleanField', ->
    describe '#validate', ->
        make_field = (name = 'test_field') ->
            field = new fields.BooleanField()
            field.setup(name)
            
            return field
        
        it 'should have sane defaults', ->
            field = make_field()
            
            expect(field.name).toEqual('test_field')
            expect(field.defaultValue).toEqual(false)
        
        it 'should raise error when value is not a bool', ->
            field = make_field()
            test = -> throw field.validate('a string')
            
            expect(test).toThrow('test_field should be a boolean value.')
        
        it 'should return true when the value is a string', ->
            field = make_field()
            
            expect(field.validate(true)).toBeTruthy()
