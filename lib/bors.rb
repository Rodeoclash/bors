require 'open3'
require 'tempfile'
require 'fileutils'

require_relative 'bors/example'
require_relative 'bors/result'
require_relative 'bors/command_line'

class Bors
	attr_reader :examples

	def initialize(options)
		@options = options
		@examples_file = File.new(options[:examples_file], 'a')
	end

	def add_example(details)
		@examples_file.write("#{Example.new(details).to_s}\n")
	end

	# returns an example from the file
	def get_example(at)
		get_line_from_file(@examples_file, at) # should convert to Example class instead of String
	end

	# returns the examples as a string in VW format
	def examples
		with_closed_examples_file do
			return File.open(@examples_file.path, 'r').read
		end
	end

	# Runs vowpal wabbit with the loaded examples
	def run!(run_options={})
		with_closed_examples_file do
			raise Exceptions::MissingExamples.new unless File.open(@examples_file.path, 'r').readlines.count > 0
			run_options.merge!({:examples => @examples_file.path})
			out = CommandLine.new(run_options).run!
			FileUtils.rm(@examples_file.path) if @options[:temp_examples] == true
			return Result.new(out)
		end
	end

	private

	def get_line_from_file(path, line)
		result = nil
		with_closed_examples_file do
			File.open(path, "r") do |f|
				while line > 0
					line -= 1
					result = f.gets
				end
			end
		end
		result
	end

	def with_closed_examples_file(&block)
		@examples_file.close unless @examples_file.closed?
		block.call
		@examples_file = File.open(@examples_file.path, 'a')
	end

end