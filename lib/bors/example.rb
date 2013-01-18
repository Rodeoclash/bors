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
			"#{label} #{importance} #{initial_prediction} #{tag}#{features}".squeeze(' ')
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

		def features
			if @options[:namespaces] && @options[:namespaces].length > 0
				@options[:namespaces].map do |name, options|
					raise Exceptions::ArgumentError.new('Incorrect format for namescape, must be defined as a Hash') unless options.kind_of? Hash
					returning = "|#{name}"
					returning += ":#{options[:value]}" if options[:value]
					returning += create_features_from_array(options[:features])
					returning += " "
				end.join.strip
			else
				returning = "|"
				returning += create_features_from_array(@options[:features])
				returning += " "
			end
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

		def create_features_from_array(features)
			features.map { |feature| " #{Feature.new(feature).to_s}" }.join
		end
		
	end
end