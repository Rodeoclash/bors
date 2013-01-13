require_relative 'bors/example'
require_relative 'bors/model'
require_relative 'bors/prediction'
require 'open3'
require 'tempfile'

class Bors

	attr_reader :examples

	def initialize(options = {})
		@examples = Tempfile.new('bors')
		@example_count = 0
		@options = options
	end

	def add_example(details)
		begin
			@examples.write("#{Example.new(details).to_s}\n")
			@example_count += 1
		end
	end

	# returns an example from the file
	def get_example(at)
		get_line_from_file(@examples, at)
	end

	# load examples from path, should automatically detect a cache file and use that instead
	def load_examples(path)

	end

	# outputs examples to the specified file
	def save_examples(path)
		raise Exceptions::MissingExamples.new unless @examples.length > 0
		# should copy tempfile to path then automatically reload it
	end

	# creates a training model from the loaded examples
	def model(path)
		raise Exceptions::MissingExamples.new unless @examples.length > 0
		err, out, status = Open3.capture3("vw #{@examples.path} -c --passes 30 -b 25 --invariant -l 10 --loss_function logistic --exact_adaptive_norm -f #{path}.model")
		Model.new(err, out, status)
	end

	# predict using a model and the loaded exampels
	def predict(model_path)
		raise Exceptions::MissingExamples.new unless @examples.length > 0
		out, err, status = Open3.capture3("vw -i #{model_path} -t #{@examples.path} -p /dev/stdout --quiet")
		Prediction.new(out)
	end

	private

	def get_line_from_file(path, line)
		result = nil
		File.open(path, "r") do |f|
			while line > 0
				line -= 1
				result = f.gets
			end
		end
		return result
	end

end