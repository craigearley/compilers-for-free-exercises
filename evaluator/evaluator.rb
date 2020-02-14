def power_5(x)
	if 5.zero?
		1
	else
		x * power(5 - 1, x)
	end
end

