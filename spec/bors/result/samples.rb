require_relative "../../spec_helper"

describe Bors::Result::Samples do

	before :each do
		@data = File.open("#{File.dirname(__FILE__)}/../../fixtures/result.txt", 'r').read
	end

	it "should be able to create the object" do
		expect { Bors::Result::Samples.new(@data) }.to_not raise_error
	end

	it "should be able to serialise the object to json" do
		Bors::Result::Samples.new(@data).to_json.kind_of?(String).should be == true
	end

end