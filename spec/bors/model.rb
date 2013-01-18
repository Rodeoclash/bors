require_relative "../spec_helper"

module Indus

	describe Bors::Model do

		before :each do
			@data = File.open("#{File.dirname(__FILE__)}/../fixtures/model.txt", 'r').read
		end

		it "should be able to create a model object" do
			expect { Bors::Model.new(@data) }.to_not raise_error
		end

		it "should return the settings of the model run" do
			#settings = Bors::Model.new(@data).settings
			#settings.kind_of?(Hash).should be == true
			#settings[:final_regressor].should eq "/bors_models/location-adelaide.model.model"
			#settings[:num_weight_bits].should eq "25"
		end

	end

end