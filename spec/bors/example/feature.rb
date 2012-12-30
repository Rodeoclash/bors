require_relative "../../spec_helper"

module Indus

	describe Bors::Example::Feature do

		before :each do
		end

		it "should be able to create a Feature object" do
			expect { Bors::Example::Feature.new("") }.to_not raise_error
		end

		it "should return the feature if given as a string" do
			Bors::Example::Feature.new("Sam").to_s.should be == "Sam"
		end

		it "should correctly split features defined as a hash" do
			Bors::Example::Feature.new({"Sam" => 1.1}).to_s.should be == "Sam:1.1"
			Bors::Example::Feature.new({:test => 1}).to_s.should be == "test:1"
		end

		it "should raise an error when defining a feature with a non real number weight" do
			expect { Bors::Example::Feature.new({:test => -1}).to_s }.to raise_error Bors::Exceptions::NotRealNumber
		end

	end

end