require_relative "../exceptions"
require_relative "../math"

class Bors
	class Example
		class Feature
			include Math

			def initialize(value)
				@value = value
			end

			def to_s
				returning = ""

				if @value.kind_of?(String)
					returning += @value
				else
					@value.each do |key, value|
						raise Exceptions::NotRealNumber.new unless is_real_number?(value)
						if key.to_s.match(/\s/)
							key.split(/\s/).each do |word|
								returning += "#{word}:#{value} "
							end
						else
							returning += "#{key}:#{value} "
						end
					end
				end

				returning.strip
			end

		end
	end
end