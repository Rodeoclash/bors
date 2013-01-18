require_relative "spec_helper"

describe Bors do

	before :each do
		@bors = Bors.new
	end

	it "should be able to create a Bors object" do
		expect { Bors.new }.to_not raise_error
	end

	it "should be able to add an example to the Bors object with full options" do
		@bors.add_example({
			:label => 0,
			:initial_prediction => 0.5,
			:importance => 1,
			:tag => "second_house",
			:namespaces => {
				"Animal" => {
					:value => 1,
					:features => [
						"Any plain old text in here",
						"or",
						"single",
						"string",
						{"NumberOfLegs with spaces in it" => 1.0},
						{"Size" => 2.0, "Weird Setup" => 1.5}
					]
				},

				"Diet" => {
					:value => 2,
					:features => [
						"Mice Rats"
					]
				}
			}
		})
	end

	it "should be possible to omit items that are not required and without a namespace" do
		@bors.add_example({
			:label => 1,
			:features => [
				{"NumberOfLegs with spaces in it" => 1.0},
				{"Strength" => 2.0, "Charisma" => 1.5}
			]
		})
	end

	it "should be possible to get the currently loaded examples as a string" do
		@bors.add_example({
			:label => 1,
			:features => [
				"Any plain old text in here",
				{"Strength" => 2.0, "Charisma" => 1.5}
			]
		})
		@bors.examples.kind_of?(String).should be == true
	end

	it "should be possible to save the examples loaded to a file" do
		path = "#{File.dirname(__FILE__)}/temp/examples.txt"
		@bors.add_example({:label => 1, :namespaces => { "text" => { :features => ["Some basic string"]} } })
		@bors.save_examples(path).should be == true
		File.exist?(path).should == true
	end

	it "should append new examples to the saved file instead of the temp file" do
		path = "#{File.dirname(__FILE__)}/temp/examples.txt"
		@bors.add_example({:label => 1, :namespaces => { "text" => { :features => ["Some basic string"]} } })
		@bors.save_examples(path).should be == true
		@bors.add_example({:label => -1, :namespaces => { "text" => { :features => ["Another basic string"]} } })
		@bors.get_example(2).should be == "-1 |text Another basic string\n"
		@bors.add_example({:label => -1, :namespaces => { "text" => { :features => ["Last basic string"]} } })
		@bors.get_example(3).should be== "-1 |text Last basic string\n"
	end

	it "should be possible to create a cache file and switch to it automatically" do
		path = "#{File.dirname(__FILE__)}/temp/examples.cached"
		@bors.add_example({:label => -1, :namespaces => { "text" => { :features => ["Another basic string"]} } })
		@bors.create_cache(path)
		File.exist?(path).should be == true
		@bors.examples_cached?.should be == true
	end

	it "should be possible to run vw without specifying any options and have it return a results object" do
		@bors.add_example({
			:label => 0,
			:namespaces => {
				"hours" => { :features => ["Some basic string"] }
			}
		})
		expect { @bors.run }.to_not raise_error
	end

	it "should automatically create a cache and switch to it if the passes run option is selected and we're not in cache mode" do
		@bors.add_example({:label => -1, :namespaces => { "text" => { :features => ["Another basic string"]} } })
		expect { @bors.run({:passes => 5}) }.to_not raise_error
		@bors.examples_cached?.should be == true
	end

end