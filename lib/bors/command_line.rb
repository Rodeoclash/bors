class Bors
	class CommandLine

		def initialize(options)
			@options = options
		end

		def generate
			"vw #{data_set} #{cache_file} #{create_cache} #{passes} #{initial_regressor} #{final_regressor} #{predictions}"
		end

		def data_set
			raise Exceptions::ArgumentError.new('You must specify a dataset for VW to work with') unless @options[:data_set]
			@options[:data_set]
		end

		def cache_file
			@options[:cache_file] ? "--cache_file #{@options[:cache_file]}" : ""
		end

		def create_cache
			raise Exceptions::ArgumentError.new('Must specify the cache file paramater as well when creating the cache') if @options[:create_cache] == true && @options[:cache_file].nil?
			@options[:create_cache] == true ? "-c #{cache_file}" : ""
		end

		def passes
			@options[:passes] ? "--passes #{@options[:passes]}" : ""
		end

		def initial_regressor
			@options[:initial_regressor] ? "-i #{@options[:initial_regressor]}" : ""
		end

		def final_regressor
			@options[:final_regressor] ? "-f #{@options[:final_regressor]}" : ""
		end

		def predictions
			@options[:predictions] ? "-p #{@options[:predictions]}" : ""
		end

		def training_mode
			@options[:training_mode] == true ? true : false
		end

	end
end

#"vw #{@examples_file.path} -c --passes 30 -b 25 --invariant -l 10 --loss_function logistic --exact_adaptive_norm -f #{path}"