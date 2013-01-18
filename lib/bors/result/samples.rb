require 'hashie'
require 'oj'

class Bors
	class Result
		class Samples
			include Enumerable

			def initialize(data)
				@samples = Array.new
				found = false

				data.each_line do |line|

					if line.match(/^\n/)
						break
					end
					if line.match('loss')
						found = true
						next
					end
					if found == true
						average_loss, since_last, example_counter, example_weight, current_label, current_predict, current_features = line.scan(/\d+\.?\d*/)
						@samples << {
							:average_loss => average_loss,
							:since_last => since_last,
							:example_counter => example_counter,
							:example_weight => example_weight,
							:current_label => current_label,
							:current_predict => current_predict,
							:current_features => current_features
						}
					end
				end
			end

			def each(&block)
				@samples.each do |sample|
					if block_given?
						block.call(sample)
					else  
						yield sample
					end
				end
			end

			def to_json
				Oj.dump(@samples)
			end

		end
	end
end