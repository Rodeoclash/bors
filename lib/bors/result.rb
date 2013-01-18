require_relative "result/settings"
require_relative "result/samples"

class Bors
	class Result
		
		def initialize(data)
			@data = data
		end

		def settings		
			@settings ||= Settings.new(@data)
		end

		def samples
			@samples ||= Samples.new(@data)
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