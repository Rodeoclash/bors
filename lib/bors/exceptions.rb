class Bors
	module Exceptions

		class BorsError < StandardError; end

		class ArgumentError < BorsError; end

		class NotRealNumber < BorsError; end

		class VWCommandLineError < BorsError; end

	end
end
