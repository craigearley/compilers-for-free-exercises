Number    = Struct.new :value
Boolean   = Struct.new :value
Variable  = Struct.new :name

Add       = Struct.new :left, :right
Multiply  = Struct.new :left, :right
LessThan  = Struct.new :left, :right

Assign    = Struct.new :name, :expression
If        = Struct.new :condition, :consequence, :alternative
Sequence  = Struct.new :first, :second
While     = Struct.new :condition, :body
