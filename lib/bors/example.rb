require_relative "exceptions"
require_relative "math"
require_relative "example/feature"

class Bors
	class Example
		include Math

		def initialize(options)
			@options = options
		end

		def to_s
			"#{label} #{importance} #{initial_prediction} #{tag}#{namespaces}".squeeze(' ')
		end

		def label
			return_options_key_if_valid_number :label
		end

		def importance
			return_options_key_if_valid_real_number :importance
		end

		def initial_prediction
			return_options_key_if_valid_real_number :initial_prediction
		end

		def tag
			if @options[:tag]
				raise Exceptions::ArgumentError.new('Tag must not contain spaces') unless @options[:tag].to_s.match(/\s/).nil?
				raise Exceptions::ArgumentError.new('Tag must be A-z-0-9') unless @options[:tag].to_s.match(/\W/).nil?
				@options[:tag]
			else
				""
			end
		end

		def namespaces
			raise Exceptions::ArgumentError.new('You must provide at least one namespace') unless @options[:namespaces] && @options[:namespaces].length > 0

			@options[:namespaces].map do |name, options|
				raise Exceptions::ArgumentError.new('Incorrect format for options, must be a Hash') unless options.kind_of? Hash
				
				returning = ""
				returning += "|#{name}"
				returning += ":#{options[:value]}" if options[:value]

				if options[:features].kind_of? Array
					options[:features].each do |feature|
						returning += " #{Feature.new(feature).to_s}"
					end
				else
					returning += " #{Feature.new(options[:features]).to_s}"
				end

				returning += " "

			end.join.strip
		end

		private

		def return_options_key_if_valid_real_number(key)
			if @options[key]
				raise Exceptions::NotRealNumber.new unless is_real_number?(@options[key])
				@options[key]
			else
				""
			end
		end

		def return_options_key_if_valid_number(key)
			if @options[key]
				raise Exceptions::NotRealNumber.new unless is_number?(@options[key])
				@options[key]
			else
				""
			end
		end
		
	end
end