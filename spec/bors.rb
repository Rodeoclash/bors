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
						"Other small animals"
					]
				}
			}
		})
	end

	it "should be possible to omit items that are not required" do
		@bors.add_example({
			:label => 1,
			:namespaces => {
				"text" => { :features => "Some basic string" }
			}
		})
	end

	it "should be possible to save the examples loaded to a file" do
		path = "#{File.dirname(__FILE__)}/temp/examples.txt"
		@bors.add_example({:label => 1, :namespaces => { "text" => { :features => "Some basic string"} } })
		@bors.save(path).should be == true
		File.exist?(path).should == true
	end

	it "should append new examples to the saved file instead of the temp file" do
		path = "#{File.dirname(__FILE__)}/temp/examples.txt"
		@bors.add_example({:label => 1, :namespaces => { "text" => { :features => "Some basic string"} } })
		@bors.save(path).should be == true
		@bors.add_example({:label => -1, :namespaces => { "text" => { :features => "Another basic string"} } })
		@bors.get_example(2).should be == "-1 |text Another basic string\n"
		@bors.add_example({:label => -1, :namespaces => { "text" => { :features => "Last basic string"} } })
		@bors.get_example(3).should be== "-1 |text Last basic string\n"
	end

end