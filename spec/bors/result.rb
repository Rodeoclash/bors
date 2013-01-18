require_relative "../spec_helper"

module Indus

	describe Bors::Result do

		before :each do
			@data = File.open("#{File.dirname(__FILE__)}/../fixtures/result.txt", 'r').read
		end

		it "should be able to create a model object" do
			expect { Bors::Result.new(@data) }.to_not raise_error
		end

		it "should return the settings of the model run" do
			settings = Bors::Result.new(@data).settings
			settings.kind_of?(Bors::Result::Settings).should be == true
		end

	end

end