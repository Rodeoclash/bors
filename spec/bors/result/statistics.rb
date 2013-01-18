require_relative "../../spec_helper"

describe Bors::Result::Statistics do

	before :each do
		@data = File.open("#{File.dirname(__FILE__)}/../../fixtures/result.txt", 'r').read
	end

	it "should be able to create the object" do
		expect { Bors::Result::Statistics.new(@data) }.to_not raise_error
	end

	it "should be able to return the object as a hash with the correct values" do
		hash = Bors::Result::Statistics.new(@data).to_h
		hash.kind_of?(Hash).should be == true
		hash[:number_of_examples].should be == 69720
		hash[:weighted_example_sum].should be == 6.972e+04
		hash[:weighted_label_sum].should be == -6.702e+04
		hash[:average_loss].should be == 0.01571
		hash[:best_constant].should be == -0.9613
		hash[:total_feature_number].should be == 289312080
	end

	it "should be able to serialise the object to json" do
		Bors::Result::Settings.new(@data).to_json.kind_of?(String).should be == true
	end

end