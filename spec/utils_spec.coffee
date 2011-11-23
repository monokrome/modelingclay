utils = require '../lib/utils'

describe 'utility belt', ->
    describe 'extend', ->
        it 'should copy key/value pairs from one object to another', ->
            objectA = 
                testKey: 'testVal1'
                
            objectB =
                otherKey: 'testVal2'
                deepObj:
                    deepKey: 'value'
            
            result = utils.extend(objectA, objectB)
            
            expect(result.testKey).toBeDefined()
            expect(result.otherKey).toBeDefined()
            expect(result.deepObj).toBeDefined()
            expect(result.deepObj.deepKey).toEqual('value')
            
        
            