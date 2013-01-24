require_relative "spec_helper"
require 'fileutils'

describe Bors do

	before :each do
		@temp_examples = "#{File.dirname(__FILE__)}/temp/tests.txt"
		FileUtils.rm(@temp_examples) if File.exists?(@temp_examples)
		@bors = Bors.new({:examples_file => @temp_examples})
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

	it "should append new examples to the saved file instead of the temp file" do
		@bors.add_example({:label => 1, :namespaces => { "text" => { :features => ["Some basic string"]} } })
		@bors.add_example({:label => -1, :namespaces => { "text" => { :features => ["Another basic string"]} } })
		@bors.get_example(2).should be == "-1 |text Another basic string\n"
		@bors.add_example({:label => -1, :namespaces => { "text" => { :features => ["Last basic string"]} } })
		@bors.get_example(3).should be== "-1 |text Last basic string\n"
	end

	it "should be possible to run vw without specifying any options and have it return a results object" do
		@bors.add_example({
			:label => 0,
			:namespaces => {
				"hours" => { :features => ["Some basic string"] }
			}
		})
		expect { @bors.run! }.to_not raise_error
	end

	it "should be possible to specify a complex set of options when running" do
		@bors.add_example({
			:label => 0,
			:namespaces => {
				"hours" => { :features => ["Some basic string"] }
			}
		})
		expect { 
			@bors.run!({
				:training_mode => true,
				:create_cache => true,
				:cache_file => "#{@temp_folder}/test.cache",
				:passes => 3,
				:predictions => "#{@temp_folder}/test.prediction",
				:min_prediction => -1,
				:max_prediction => 1,
				:ngrams => 2
			})
		}.to_not raise_error
	end

	it "should be possible to catch VW command line errors" do
		@bors.add_example({
			:label => 0,
			:namespaces => {
				"hours" => { :features => ["Some basic string"] }
			}
		})
		expect { 
			@bors.run!({
				:passes => 2,
			})
		}.to raise_error
	end

end