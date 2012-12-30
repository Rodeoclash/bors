require_relative "prediction/result"

class Bors
	class Prediction

		def initialize(output)
			@output = output
		end

		def each(&block)
			@output.each_line do |line|
				block.call( Result.new(line) )
			end
		end

	end
end