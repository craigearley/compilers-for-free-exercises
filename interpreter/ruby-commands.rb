Number	= Struct.new :value
require('treetop')

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
end

class Boolean
	def evaluate(environment)
		value
	end
end

class Variable
	def evaluate(environment)
		environment[name]
	end
end

class Add
	def evaluate(environment)
		left.evaluate(environment) + right.evaluate(environment)
	end
end

class Multiply
	def evaluate(environment)
		left.evaluate(environment) * right.evaluate(environment)
	end
end

class LessThan
	def evaluate(environment)
		left.evaluate(environment) < right.evaluate(environment)
	end
end

class Assign
	def evaluate(environment)
		environment.merge({ name => expression.evaluate(environment) })
	end
end

class Sequence
	def evaluate(environment)
		second.evaluate(first.evaluate(environment))
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
end

class While
	def evaluate(environment)
		if condition.evaluate(environment)
			evaluate(body.evaluate(environment))
		else
			environment
		end
	end
end

