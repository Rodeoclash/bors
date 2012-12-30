class Bors
	module Exceptions

		class BorsError < StandardError; end

		class ArgumentError < BorsError; end

		class NotRealNumber < BorsError; end

		class MissingExamples < BorsError; end

	end
end
