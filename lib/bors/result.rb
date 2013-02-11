require_relative "result/settings"
require_relative "result/samples"
require_relative "result/statistics"

class Bors
	class Result

		attr_reader :data
		
		def initialize(data)
			@data = data
		end

		def settings		
			@settings ||= Settings.new(@data)
		end

		def samples
			@samples ||= Samples.new(@data)
		end

		def statistics
			@statistics ||= Statistics.new(@data)
		end

	end
end