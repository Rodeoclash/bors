require_relative "../spec_helper"

module Indus

	describe Bors::Example do

		it "should be able to create a new item without errors when given options" do
			expect { Bors::Example.new({}) }.to_not raise_error
		end

		it "should allow you to define a label for the object" do
			Bors::Example.new({ :label => 1 }).label.should == 1
		end

		it "should allow you to define a negative label for the object" do
			Bors::Example.new({ :label => -1 }).label.should == -1
		end

		it "should raise an error when trying to define an invalid label" do
			expect { Bors::Example.new({ :label => "invalid" }).label }.to raise_error Bors::Exceptions::NotRealNumber
		end

		it "should allow you to define an importance for the object" do
			Bors::Example.new({ :importance => 1.0 }).importance.should == 1.0
		end

		it "should raise an error when trying to define an invalid importance" do
			expect { Bors::Example.new({ :importance => -1 }).importance }.to raise_error Bors::Exceptions::NotRealNumber
		end

		it "should allow you to define an initial prediction for the object" do
			Bors::Example.new({ :initial_prediction => 1 }).initial_prediction.should == 1
		end

		it "should raise an error when trying to define an invalid initial_prediction" do
			expect { Bors::Example.new({ :importance => "invalid" }).importance }.to raise_error Bors::Exceptions::NotRealNumber
		end

		it "should allow you to define a tag for the object" do
			Bors::Example.new({ :tag => "Sam" }).tag.should == "Sam"
		end

		it "should raise an error when trying to a tag which contains spaces" do
			expect { Bors::Example.new({ :tag => "No spaces" }).tag }.to raise_error Bors::Exceptions::ArgumentError
		end

		it "should raise an error when trying to a tag which contains invalid characters" do
			expect { Bors::Example.new({ :tag => "nospecial?*" }).tag }.to raise_error Bors::Exceptions::ArgumentError
		end

		it "should allow you to define a namespace" do
			Bors::Example.new({ :namespaces => {
					"Diet" => {
						:value => 2,
						:features => [
							"Other small animals"
						]
					},
					"Description" => {
						:value => 16,
						:features => [
							{"Legs" => 4},
							{"Horns" => 2}
						]
					}
				}
			}).features.should == "|Diet:2 Other small animals |Description:16 Legs:4 Horns:2"
		end

	end

end