require 'hashie'
require 'oj'

class Bors
	class Result
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
				hash = Hash.new
				hash[:final_regressor] = self.final_regressor if self.respond_to?(:final_regressor)
				hash[:num_weight_bits] = self.num_weight_bits.to_i if self.respond_to?(:num_weight_bits)
				hash[:learning_rate] = self.learning_rate.to_i if self.respond_to?(:learning_rate)
				hash[:initial_t] = self.initial_t.to_f if self.respond_to?(:initial_t)
				hash[:power_t] = self.power_t.to_f if self.respond_to?(:power_t)
				hash[:decay_learning_rate] = self.decay_learning_rate.to_i if self.respond_to?(:decay_learning_rate)
				hash[:creating_cache_file] = self.creating_cache_file if self.respond_to?(:creating_cache_file)
				#hash[:reading_from = self.reading_from # not matching due to lack of equals in output
				hash[:num_sources] = self.num_sources.to_i if self.respond_to?(:num_sources)
				hash
			end

			def to_json
				Oj.dump(self.to_h)
			end

		end
	end
end