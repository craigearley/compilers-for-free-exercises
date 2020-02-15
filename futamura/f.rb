def read_source
	'x = 2; y = x * 3'
end

def read_environment
	{}
end

Number	= Struct.new :value
require('treetop')
require('json')

Treetop.load('simple.treetop')

Boolean  = Struct.new :value
Variable = Struct.new :name

Add	  = Struct.new :left, :right
Multiply  = Struct.new :left, :right
LessThan  = Struct.new :left, :right

Assign	= Struct.new :name, :expression
If	= Struct.new :condition, :consequence, :alternative
Sequence = Struct.new :first, :second
While	 = Struct.new :condition, :body

class Number
	def evaluate(environment)
		value
	end
	def to_javascript
		"function (e) { return #{JSON.dump(value)}; }"
	end
end

class Boolean
	def evaluate(environment)
		value
	end
	def to_javascript
		"function (e) { return #{JSON.dump(value)}; }"
	end
end

class Variable
	def evaluate(environment)
		environment[name]
	end
	def to_javascript
		"function (e) { return #{JSON.dump(name)}; }"
	end
end

class Add
	def evaluate(environment)
		left.evaluate(environment) + right.evaluate(environment)
	end
	def to_javascript
		"function (e) { return #{left.to_javascript}(e) + #{right.to_javascript}(e); }"
	end
end

class Multiply
	def evaluate(environment)
		left.evaluate(environment) * right.evaluate(environment)
	end
	def to_javascript
		"function (e) { return #{left.to_javascript}(e) * #{right.to_javascript}(e); }"
	end
end

class LessThan
	def evaluate(environment)
		left.evaluate(environment) < right.evaluate(environment)
	end
	def to_javascript
		"function (e) { return #{left.to_javascript}(e) < #{right.to_javascript}(e); }"
	end
end

class Assign
	def evaluate(environment)
		environment.merge({ name => expression.evaluate(environment) })
	end
	def to_javascript
		"function (e) { e[#{JSON.dump(name)}] = #{expression.to_javascript}(e); return e; }"
	end
end

class Sequence
	def evaluate(environment)
		second.evaluate(first.evaluate(environment))
	end
	def to_javascript
		"function (e) { return #{second.to_javascript}(#{first.to_javascript}(e)); }"
	end
end

class If
	def evaluate(environment)
		if condition.evaluate(environment)
			consequence.evaluate(environment)
		else
			alternative.evaluate(environment)
		end
	end
	def to_javascript
		"function (e) { if (#{condition.to_javascript}(e))" + 
			" { return #{consequence.to_javascript}(e); }" + 
			" else { return #{alternative.to_javascript}(e); }" +
			' }'
	end
end

class While
	def evaluate(environment)
		if condition.evaluate(environment)
			evaluate(body.evaluate(environment))
		else
			environment
		end
	end
	def to_javascript
		'function (e) {' +
			" while (#{condition.to_javascript}(e)) { e = #{body.to_javascript}(e); }" +
			' return e;' +
		' }'
	end
end

source, environment = read_source, read_environment

Treetop.load('simple.treetop')
environment = read_environment

# initial step
ast = SimpleParser.new.parse(source).to_ast
puts ast.evaluate(environment)

# step after copy propagation and expression's replacement with AST
ast = Sequence.new(
		Assign.new(
		  :x,
		  Number.new(2)
		),
		Assign.new(
		  :y,
		  Multiply.new(
			Variable.new(:x),
			Number.new(3)
		  )
		)
	  )
puts ast.evaluate(environment)


