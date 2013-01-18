require_relative "model/settings"

class Bors
	class Model
		
		def initialize(data)
			@data = data
		end

		def settings
			return @settings unless @settings.nil?
			@settings = Settings.new
			
			@data.each_line do |line|
				return @settings if line.match('loss')

				line.match(/\s=\s/) do |m|
					label, value = split_line(line)
					@settings[format_label(label)] = format_value(value)
				end

			end
		end

		def sample
			return @sample unless @sample.nil?
			@sample = Array.new
			found = false
			@data.each_line do |line|
				if line.match(/^\n/)
					return @sample
				end
				if line.match('loss')
					found = true
					next
				end
				if found == true
					average_loss, since_last, example_counter, example_weight, current_label, current_predict, current_features = line.scan(/\d+\.?\d*/)
					@sample.push({
						:average_loss => average_loss,
						:since_last => since_last,
						:example_counter => example_counter,
						:example_weight => example_weight,
						:current_label => current_label,
						:current_predict => current_predict,
						:current_features => current_features
					})
				end
			end
		end

		def results
			return @settings unless @settings.nil?
			@settings = Hash.new
			@data.each_line do |line|
				if line.match('finished run')
					found = true
					next
				end
				if found == true
					line.match(/\s=\s/) do |m|
						label, value = split_line(line)
						@settings[format_label(label)] = format_value(value)
					end
				end
			end
		end

		private

		def split_line(line)
			line.split(/\s=\s/)
		end

		def format_label(label)
			label.gsub(' ', '_').downcase.to_sym
		end

		def format_value(value)
			value.delete("\n")
		end

	end
end