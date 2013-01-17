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
	end

	def add_example(details)
		@examples_file.write("#{Example.new(details).to_s}\n")
	end

	# returns an example from the file
	def get_example(at)
		get_line_from_file(@examples_file, at)
	end

	# load examples from path, should automatically detect a cache file and use that instead
	def load(path)

	end

	# outputs examples to the specified file
	def save(path)
		raise Exceptions::MissingExamples.new unless @examples_file.length > 0
		FileUtils.cp(@examples_file.path, path)
		@examples_file = File.open(path, 'a')
	end

	# creates a training model from the loaded examples
	def model(path)
		raise Exceptions::MissingExamples.new unless @examples_file.length > 0
		err, out, status = Open3.capture3("vw #{@examples_file.path} -c --passes 30 -b 25 --invariant -l 10 --loss_function logistic --exact_adaptive_norm -f #{path}")
		Model.new(err, out, status)
	end

	# predict using a model and the loaded exampels
	def predict(model_path)
		raise Exceptions::MissingExamples.new unless @examples_file.length > 0
		out, err, status = Open3.capture3("vw -i #{model_path} -t #{@examples_file.path} -p /dev/stdout --quiet")
		Prediction.new(out)
	end

	private

	def get_line_from_file(path, line)
		@examples_file.close
		result = nil
		File.open(path, "r") do |f|
			while line > 0
				line -= 1
				result = f.gets
			end
		end
		@examples_file = File.open(@examples_file.path, 'a')
		result
	end

end