def power(n, x)
	if n.zero?
		1
	else
		x * power(n - 1, x)
	end
end

