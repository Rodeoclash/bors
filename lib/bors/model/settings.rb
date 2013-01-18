require 'hashie'
require 'oj'

class Bors
	class Model
		class Settings < Hash
			include Hashie::Extensions::MethodAccess

			def initialize(data)
				split_regex = /\s=\s/
				@data = data
				@data.each_line do |line|
					line.match(split_regex) do |m|
						label, value = line.split(split_regex)
						self.send("#{label}=".gsub(' ', '_').downcase, value.gsub("\n", ""))
					end
				end				
			end

			def to_h
				{
					:final_regressor => self.final_regressor,
					:num_weight_bits => self.num_weight_bits.to_i,
					:learning_rate => self.learning_rate.to_i,
					:initial_t => self.initial_t.to_f,
					:power_t => self.power_t.to_f,
					:decay_learning_rate => self.decay_learning_rate.to_i,
					:creating_cache_file => self.creating_cache_file,
					#:reading_from => self.reading_from, # not matching due to lack of equals in output
					:num_sources => self.num_sources.to_i
				}
			end

			def to_json
				Oj.dump(self.to_h)
			end

		end
	end
end