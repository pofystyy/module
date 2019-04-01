values = %w(meth my qwerty instance)
p values.map.with_index { |val, ind| ind.even? ? val : val.capitalize }