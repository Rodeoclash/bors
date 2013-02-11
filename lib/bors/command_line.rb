class Bors
	class CommandLine

		def initialize(options)
			@options = options
		end

		def to_s
			"vw --data #{examples} #{training_mode} #{cache_file} #{create_cache} #{passes} #{initial_regressor} #{bit_precision} #{quadratic} #{ngram} #{final_regressor} #{predictions} #{min_prediction} #{max_prediction} #{loss_function}".squeeze(' ')
		end

		def examples
			@options[:examples]
		end

		def create_cache
			@options[:create_cache] == true ? "-c" : nil
		end

		def training_mode
			@options[:training_mode] == true ? "-t" : nil
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