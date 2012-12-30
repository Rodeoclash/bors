require_relative "spec_helper"

module Indus

	describe Bors do

		before :each do
		end

		it "should be able to create a Bors object" do
			expect { Bors.new }.to_not raise_error
		end

		it "should be able to add an example to the Bors object with full options" do
			bors = Bors.new
			bors.add_example({
				:label => 0,
				:initial_prediction => 0.5,
				:importance => 1,
				:tag => "second_house",

				# required to have at least 1
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
			bors = Bors.new
			bors.add_example({

				# real number we're trying to predict
				:label => 1,

				# required to have at least 1
				:namespaces => {
					"text" => { :features => "Some basic string" }
				}
			})
		end

	end

end