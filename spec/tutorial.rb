require_relative "spec_helper"

describe Bors do

	it "should run the tutorial described in the README.md without error" do
		temp_folder = "#{File.dirname(__FILE__)}/temp"

		bors = Bors.new({:examples_file => "#{temp_folder}/tutorial.txt"})

		bors.add_example({ :label => 0, :features => [{"price" => 0.23, "sqft" => 0.25, "age" => 0.05}, "2006"] })
		bors.add_example({ :label => 1, :importance => 2, :tag => "second_house", :features => [{"price" => 0.18, "sqft" => 0.15, "age" => 0.35}, "1976"] })
		bors.add_example({ :label => 0, :importance => 1, :prediction => 0.5, :tag => "third_house", :features => [{"price" => 0.53, "sqft" => 0.32, "age" => 0.87}, "1924"] })
		
		result = bors.run!

		result.settings.to_h
		
		bors.run!({:final_regressor => "#{File.dirname(__FILE__)}/temp/tutorial.model"})
		bors.run!({:predictions => "#{File.dirname(__FILE__)}/temp/tutorial.predictions"})

		bors.run!({:final_regressor => "#{File.dirname(__FILE__)}/temp/tutorial.model", :passes => 25, :cache_file => "#{File.dirname(__FILE__)}/temp/tutorial.cache"})
		bors.run!({:initial_regressor => "#{File.dirname(__FILE__)}/temp/tutorial.model", :predictions => "~/tutorial_examples.predictions", :training_mode => true})
	end

end