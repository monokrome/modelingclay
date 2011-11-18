Query = require('../../../models/adapters/query').Query

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
			
			q.join('another_table', 'my_field__eq', 4)
			expect(q.joins).toContain(new Join('another_table', '`my_field` = ?', 4))
			
			q.join('another_table', 'my_field__eq', 'another_field')
			expect(q.joins).toContain(new Join('another_table', '`my_field` = `another_field`'))
	
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
			
			expect(q.toString()).toEqual('SELECT `some_field`, `another_field` FROM `a_table` WHERE (`some_field` <> ?)')
			
			