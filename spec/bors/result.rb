require_relative "../spec_helper"

module Indus

	describe Bors::Result do

		before :each do
			@data = File.open("#{File.dirname(__FILE__)}/../fixtures/result.txt", 'r').read
		end

		it "should be able to create a model object" do
			expect { Bors::Result.new(@data) }.to_not raise_error
		end

		it "should return settings of the model run" do
			settings = Bors::Result.new(@data).settings
			settings.kind_of?(Bors::Result::Settings).should be == true
		end

		it "should return samples of the model run" do
			samples = Bors::Result.new(@data).samples
			samples.kind_of?(Bors::Result::Samples).should be == true
		end

		it "should return statistics of the model run" do
			statistics = Bors::Result.new(@data).statistics
			statistics.kind_of?(Bors::Result::Statistics).should be == true
		end

	end

end