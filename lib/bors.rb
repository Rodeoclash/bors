require 'open3'
require 'tempfile'
require 'fileutils'

require_relative 'bors/example'
require_relative 'bors/result'
require_relative 'bors/command_line'

class Bors
	attr_reader :examples

	def initialize
		@examples_file = Tempfile.new('bors')
		@options = Hash.new
		@options[:cached_examples] = false
	end

	def add_example(details)
		raise Exceptions::CachedExamplesEnabled.new if examples_cached?
		@examples_file.write("#{Example.new(details).to_s}\n")
	end

	# returns an example from the file
	def get_example(at)
		raise Exceptions::CachedExamplesEnabled.new if examples_cached?
		get_line_from_file(@examples_file, at)
	end

	# load examples from path, using this removes the read only mode of bors
	def load_examples(path)
		@options[:cached_examples] = false
		true
	end

	# outputs examples to the specified file
	def save_examples(path)
		raise Exceptions::CachedExamplesEnabled.new if examples_cached?
		raise Exceptions::MissingExamples.new unless @examples_file.length > 0
		FileUtils.cp(@examples_file.path, path)
		@examples_file = File.open(path, 'a')
		true
	end

	# loads a cache file, using this puts bors into read only mode
	def load_cache(path)
		@examples_file = File.open(path, 'r')
		@options[:cached_examples] = true
		true
	end

	# saves a cache file, automatically switches vw to use it and flips to read only cached mode
	def create_cache(path = nil)
		cache_path = path || "#{@examples_file.path}.cache"
		FileUtils.rm(cache_path) if File.exists?(cache_path)
		err, out, status = Open3.capture3(CommandLine.new({:data_set => @examples_file.path, :cache => cache_path}).generate)
		load_cache(cache_path)
	end

	def examples_cached?
		@options[:cached_examples] == true
	end

	# returns the examples as a string in VW format
	def examples
		raise Exceptions::CachedExamplesEnabled.new if examples_cached?
		with_closed_examples_file do
			return File.open(@examples_file.path, 'r').read
		end
	end

	# Runs vowpal wabbit with the loaded examples
	def run(run_options={})
		raise Exceptions::MissingExamples.new unless @examples_file.length > 0

		# if multiple passes are selected and we're not using cached examples, create a cache and switch to it before proceeding
		create_cache if @options[:cached_examples] == false && run_options[:passes]

		# pass in the reference to the cache file if we're using one
		run_options.merge!({:cache => @examples_file.path}) if examples_cached?

		run_options.merge!({:data_set => @examples_file.path})
		err, out, status = Open3.capture3(CommandLine.new(run_options).generate)
		Result.new(out)
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
		@examples_file.close
		block.call
		@examples_file = File.open(@examples_file.path, 'a')
	end

end