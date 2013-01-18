require 'open3'
require 'tempfile'
require 'fileutils'

require_relative 'bors/example'
require_relative 'bors/model'
require_relative 'bors/prediction'

class Bors
	attr_reader :examples

	def initialize(options = {})
		@examples_file = Tempfile.new('bors')
		@options = options
		@options[:ready_only_mode] = false
	end

	def add_example(details)
		@examples_file.write("#{Example.new(details).to_s}\n")
	end

	# returns an example from the file
	def get_example(at)
		get_line_from_file(@examples_file, at)
	end

	# load examples from path, using this removes the read only mode of bors
	def load_examples(path)
		@options[:ready_only_mode] = false
		true
	end

	# loads a cache file, using this puts bors into read only mode
	def load_cache
		@options[:ready_only_mode] = true
	end

	# outputs examples to the specified file
	def save_examples(path)
		raise Exceptions::MissingExamples.new unless @examples_file.length > 0
		FileUtils.cp(@examples_file.path, path)
		@examples_file = File.open(path, 'a')
		true
	end

	# returns the examples as a string in VW format
	def examples
		with_closed_examples_file do
			return File.open(@examples_file.path, 'r').read
		end
	end

	# creates a training model from the loaded examples
	def model(path)
		raise Exceptions::MissingExamples.new unless @examples_file.length > 0
		out, err, status = Open3.capture3("vw #{@examples_file.path} -c --passes 30 -b 25 --invariant -l 10 --loss_function logistic --exact_adaptive_norm -f #{path}")
		Model.new(out)
	end

	# predict using a model and the loaded exampels
	def predict(model_path)
		raise Exceptions::MissingExamples.new unless @examples_file.length > 0
		out, err, status = Open3.capture3("vw -i #{model_path} -t #{@examples_file.path} -p /dev/stdout --quiet")
		Prediction.new(out)
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