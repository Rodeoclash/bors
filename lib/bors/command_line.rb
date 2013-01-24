class Bors
	class CommandLine

		def initialize(options)
			@options = options
		end

		def to_s
			"vw #{examples} #{cache_file} #{create_cache} #{passes} #{initial_regressor} #{final_regressor} #{predictions} #{min_prediction} #{max_prediction}"
		end

		def examples
			@options[:examples]
		end

		def create_cache
			raise Exceptions::ArgumentError.new('Must specify the cache file paramater as well when creating the cache') if @options[:create_cache] == true && @options[:cache_file].nil?
			@options[:create_cache] == true ? "-c" : ""
		end

		def training_mode
			@options[:training_mode] == true ? true : false
		end

		def run!
			puts "VW Command: #{to_s}"
			stdout_str, stderr_str, status = Open3.capture3(to_s)
			raise Exceptions::VWCommandLineError.new(stderr_str) if status.success? == false
			stdout_str
		end

		private

		def method_missing(m, *args, &block)
			@options[m.to_sym] ? "--#{m.to_s} #{@options[m.to_sym]}" : nil
		end

	end
end