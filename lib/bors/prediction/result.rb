class Bors
	class Prediction
		class Result

			def initialize(result)
				@result = result.split(' ')
			end

			def tag
				@result[1]
			end

			def value
				@result[0]
			end

		end
	end
end