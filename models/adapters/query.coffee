SQL_EXPRESSION_TRANSLATION = {
	'neq': '<>',
	'eq': '=',
	'gt': '>',
	'gte': '>=',
	'lt': '<',
	'lte': '<=',
}

class Query
	constructor: ->
		@type = null
		@select_fields = null
		@where_clauses = null
	
	select: (fields...) ->
		@type = 'select'
		
		if fields.length > 0
			@select_fields = fields
		else
			@select_fields = '*'
		
		return this
	
	from: (primary_table) ->
		if typeof primary_table isnt 'string'
			throw {
				name: 'Error',
				message: 'Table name should be a string.'
			}
			
		@primary_table = primary_table
		
		return this
	
	join: (table_name, expression, value) ->
		
	
	where: (expression, value) ->
		field_name = expression
		sql_expression = '='
		
		if expression.indexOf('__') > -1
			[left_side, right_side] = expression.split('__')
			
			if not right_side in SQL_EXPRESSION_TRANSLATION
				throw {
					name: 'Error',
					message: "Expression not understood: #{expression}"
				}
			
			field_name = left_side
			sql_expression = SQL_EXPRESSION_TRANSLATION[right_side]
		
		@where_clauses ||= []
		@where_clauses.push(["#{@escapeField(field_name)} #{sql_expression} ?", value])
		
		return this
	
	escapeField: (fieldName) ->
		return "`#{fieldName}`"
	
	toString: ->
		queryParts = [];
		
		switch @type
			when 'select'
				queryParts.push('SELECT')
				
				if @select_fields is '*'
					queryParts.push('*')
				else
					@select_fields = (@escapeField(field) for field in @select_fields)
					
					queryParts.push(@select_fields.join(', '))
		
		queryParts.push("FROM #{@escapeField(@primary_table)}")
		
		if @where_clauses.length? > 0
			queryParts.push('WHERE')
			for clause in @where_clauses
				queryParts.push("(#{clause[0]})")
		
		return queryParts.join(' ')
	

exports.Query = Query

