class Bors
	module Maths

		def is_real_number?(value)
			(value.kind_of?(Float) || value.kind_of?(Integer)) && value.to_f >= 0
		end

	end
end