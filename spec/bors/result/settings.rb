require_relative "../../spec_helper"

describe Bors::Result::Settings do

	before :each do
		@data = File.open("#{File.dirname(__FILE__)}/../../fixtures/result.txt", 'r').read
	end

	it "should be able to create the object" do
		expect { Bors::Result::Settings.new(@data) }.to_not raise_error
	end

	it "should be able to return the object as a hash with the correct values" do
		hash = Bors::Result::Settings.new(@data).to_h
		hash.kind_of?(Hash).should be == true
		hash[:final_regressor].should be == "/bors_models/location-adelaide.model.model"
		hash[:num_weight_bits].should be == 25
		hash[:learning_rate].should be == 10
		hash[:initial_t].should be == 0
		hash[:power_t].should be == 0.5
		hash[:decay_learning_rate].should be == 1
		hash[:creating_cache_file].should be == "/var/folders/ny/vd6j4wq12pz4y96n8v3487cc0000gn/T/bors20130117-24035-xuv6sw.cache"
		#hash[:reading_from].should be == "/var/folders/ny/vd6j4wq12pz4y96n8v3487cc0000gn/T/bors20130117-24035-xuv6sw"
		hash[:num_sources].should be == 1
	end

	it "should be able to serialise the object to json" do
		Bors::Result::Settings.new(@data).to_json.kind_of?(String).should be == true
	end

end