Join = require('./join').Join

SQL_EXPRESSION_TRANSLATION = {
    'neq': '<>',
    'eq': '=',
    'gt': '>',
    'gte': '>=',
    'lt': '<',
    'lte': '<=',
}

class Query
    constructor: (@adapter) ->
        @type = null
        @select_fields = null
        @primary_table = null
        @joins = null
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
    
    join: (primary_table, primary_field, secondary_table, secondary_field) ->
        this._add_join(new Join(primary_table, primary_field, secondary_table, secondary_field))
        
        return this
    
    _add_join: (join_obj) ->
        if not @primary_table
            throw {
                name: 'Error',
                message: 'Cannot call join() before from()'
            }
        
        @joins ||= []
        
        @joins.push(join_obj)
    
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
        queryParts = []
        @valuesList = []
        
        switch @type.toLowerCase()
            when 'select'
                if @select_fields is '*'
                    queryParts.push('SELECT *')
                else
                    fields = (@escapeField(field) for field in @select_fields)
                    
                    queryParts.push("SELECT #{fields.join(', ')}")
        
        queryParts.push("FROM #{@escapeField(@primary_table)}")
        
        if @joins and @joins.length? > 0
            for join in @joins
                queryParts.push(join.toString())
        
        if @where_clauses and @where_clauses.length? > 0
            queryParts.push('WHERE')
            for clause in @where_clauses
                queryParts.push("\t(#{clause[0]})")
                @valuesList.push(clause[1])
        
        return queryParts.join('\n')
    
    execute: ->
        return @adapter.execute(this.toString(), @valuesList)
    

exports.Query = Query

