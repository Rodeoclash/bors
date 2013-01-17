class Bors
	module Math

		def is_real_number?(value)
			is_number?(value) && value >= 0
		end

		def is_number?(value)
			value.kind_of?(Float) || value.kind_of?(Integer)
		end

	end
end