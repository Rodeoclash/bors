require_relative "spec_helper"

describe Bors do

	it "should run the tutorial described in the README.md without error" do
		bors = Bors.new

		bors.add_example({ :label => 0, :features => [{"price" => 0.23, "sqft" => 0.25, "age" => 0.05}, "2006"] })
		bors.add_example({ :label => 1, :importance => 2, :tag => "second_house", :features => [{"price" => 0.18, "sqft" => 0.15, "age" => 0.35}, "1976"] })
		bors.add_example({ :label => 0, :importance => 1, :prediction => 0.5, :tag => "third_house", :features => [{"price" => 0.53, "sqft" => 0.32, "age" => 0.87}, "1924"] })
		result = bors.run
		result.settings.to_h

		bors.save_examples("#{File.dirname(__FILE__)}/temp/tutorial.txt")
		#bors.load_examples("#{File.dirname(__FILE__)}/temp/tutorial.txt") # not implemented yet

	end

end