class Bors
	class CommandLine

		def initialize(options)
			@options = options
		end

		def generate
			"vw #{data_set} #{cache} #{passes}"
		end

		def data_set
			raise Exceptions::ArgumentError.new('You must specify a dataset for VW to work with') unless @options[:data_set]
			@options[:data_set]
		end

		def cache
			@options[:cache] ? "-c --cache_file #{@options[:cache]}" : ""
		end

		def passes

		end

	end
end

#"vw #{@examples_file.path} -c --passes 30 -b 25 --invariant -l 10 --loss_function logistic --exact_adaptive_norm -f #{path}"