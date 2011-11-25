fields = require('../../lib/fields')


describe 'IntegerField', ->
    describe '#validate', ->
        make_field = (optsHash, name = 'test_field') ->
            field = new fields.IntegerField(optsHash)
            field.setup(name)
            
            return field
        
        it 'should have sane defaults', ->
            field = make_field()
            
            expect(field.name).toEqual('test_field')
            expect(field.options.default).toEqual(0)
            expect(field.options.max).toEqual(false)
            expect(field.options.min).toEqual(false)
        
        it 'should raise error when value is not a number', ->
            field = make_field()
            test = -> throw field.validate('10')
            
            expect(test).toThrow('test_field should be a number.')
        
        it 'should return true when the value is a string', ->
            field = make_field()
            
            expect(field.validate(100)).toBeTruthy()
            expect(field.validate(100.01)).toBeTruthy()
        
        it 'should raise an error when a minimum is set and the value is lower', ->
            field = make_field(min: 10)
            test = -> throw field.validate(9)
            
            expect(test).toThrow('test_field should be greater than 10.')
            
        it 'should raise an error when a maximum is set and the value is greater', ->
            field = make_field(max: 10)
            test = -> throw field.validate(90)

            expect(test).toThrow('test_field should be less than 10.')
