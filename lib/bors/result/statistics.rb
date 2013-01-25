require 'hashie'
require 'oj'

class Bors
	class Result
		class Statistics < Hashie::Mash

			SPLIT_SETTINGS_LINE = /\s=\s/

			def initialize(data)
				lines = String.new
				found = false

				data.each_line do |line|
					if line.match('finished run') && found == false
						found = true
						next
					end
					if found == true
						lines += line
					end
				end

				lines.each_line do |line|
					line.match(SPLIT_SETTINGS_LINE) do |m|
						label, value = line.split(SPLIT_SETTINGS_LINE)
						self.send("#{label}=".gsub(' ', '_').downcase, value.gsub("\n", ""))
					end
				end

			end

			def to_h
				hash = Hash.new
				hash[:number_of_examples] = self.number_of_examples.to_i
				hash[:weighted_example_sum] = self.weighted_example_sum.to_f
				hash[:weighted_label_sum] = self.weighted_label_sum.to_f
				hash[:average_loss] = self.average_loss.to_f
				hash[:best_constant] = self.best_constant.to_f
				hash[:total_feature_number] = self.total_feature_number.to_i
				hash
			end

			def to_json
				Oj.dump(self.to_h)
			end

		end
	end
end