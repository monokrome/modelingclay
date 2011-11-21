AdapterInterface = require('../../../models/adapters/interface').AdapterInterface
Query = require('../../../models/query').Query
Join = require('../../../models/join').Join

describe 'Query', ->
    describe '#select', ->
        it 'should set type and fields list', ->
            q = new Query()
            q.select('field1', 'field2')
            
            expect(q.type).toEqual('select')
            expect(q.select_fields).toContainExactly('field1', 'field2')
        it 'when no fields are specified it should select all of them', ->
            q = new Query()
            q.select()
            
            expect(q.type).toEqual('select')
            expect(q.select_fields).toEqual('*')
        
        it 'should support chaining', ->
            q = new Query()
            expect(q.select()).toBe(q)
        
    describe '#from', ->
        it 'sets the target table', ->
            q = new Query()
            q.from('some_table')
            
            expect(q.primary_table).toEqual('some_table')
        it 'when table name is not a string, an error is thrown', ->
            q = new Query()
            
            test = ->
                throw q.from(1293729183)
                
            expect(test).toThrow('Table name should be a string.')
        
        it 'should support chaining', ->
            q = new Query()
            expect(q.from('test')).toBe(q)
    
    describe '#join', ->
        it 'adds a new row to the joins list', ->
            q = new Query()
            q.from('primary_table')
            
            q.join('primary_table', 'some_field', 'another_table', 'my_field')
            expect(q.joins).toContain(new Join('primary_table', 'some_field', 'another_table', 'my_field'))
        
        it 'throws an error if called before from()', ->
            q = new Query()
            
            test = ->
                throw q.join('primary_table', 'some_field', 'another_table', 'my_field')
            
            expect(test).toThrow('Cannot call join() before from()')
            
    
    describe '#where', ->
        it 'can parse simple operators and generate proper sql clause', ->
            q = new Query()
            q.where('field__eq', 1)
            q.where('field__neq', 2)
            q.where('field__gt', 100)
            q.where('field__gte', 200)
            q.where('field__lt', 100)
            q.where('field__lte', 200)
            
            expect(q.where_clauses).toContain(['`field` = ?', 1])
            expect(q.where_clauses).toContain(['`field` <> ?', 2])
            expect(q.where_clauses).toContain(['`field` > ?', 100])
            expect(q.where_clauses).toContain(['`field` >= ?', 200])
            expect(q.where_clauses).toContain(['`field` < ?', 100])
            expect(q.where_clauses).toContain(['`field` <= ?', 200])
        
        it 'should support chaining', ->
            q = new Query()
            expect(q.where('something', 1)).toBe(q)
            
    describe '#toString', ->
        it 'should work with simple select from where queries', ->
            q = new Query()
            
            q.select('some_field', 'another_field').from('a_table').where('some_field__neq', 'my_value')
            
            expect(q.toString()).toEqual("SELECT `some_field`, `another_field`\nFROM `a_table`\nWHERE\n\t(`some_field` <> ?)")
        
        it 'should work with joins', ->
            q = new Query()
            
            q.select('some_field', 'another_field').from('a_table').join('a_table', 'some_field', 'table_b', 'field_b').where('some_field__neq', 'my_value')
            
            expect(q.toString()).toEqual("SELECT `some_field`, `another_field`\nFROM `a_table`\nJOIN `table_b` ON (`a_table`.`some_field` = `table_b`.`field_b`)\nWHERE\n\t(`some_field` <> ?)")
            
    describe '#execute', ->
        it 'should call through to the adapter', ->
            fakeAdapter = {
                execute: ->
                    # do nothing.
            }
            
            spyOn(fakeAdapter, 'execute')
              
            q = new Query(fakeAdapter)
            q.select('some_field', 'another_field').from('a_table').join('a_table', 'some_field', 'table_b', 'field_b').where('some_field__neq', 'my_value')
            q.execute()
            
            expect(fakeAdapter.execute).toHaveBeenCalledWith(q.toString(), ['my_value'], q._handleExecute)
        
    describe '#_handleExecute', ->
        it 'should store the results', ->
            fake_rows = [
                [1, 'string'],
                [2, 'another string']
            ]
            
            fake_fields = ['id', 'thing']
            
            q = new Query()
            q._handleExecute(null, fake_rows, fake_fields)
            
            expect(q._results.length).toEqual(2)
            expect(q._results).toContain({id: 1, thing: 'string'})
            expect(q._results).toContain({id: 2, thing: 'another string'})
        