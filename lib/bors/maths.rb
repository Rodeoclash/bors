class Bors
	module Maths

		def is_real_number?(value)
			(value.kind_of?(Float) || value.kind_of?(Integer))
		end

	end
end