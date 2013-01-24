# Bors

> "One rabbit stew coming right up!"

Bors is a wrapper for the Vowpal Wabbit library by John Langford. It consists of a wrapper around the command line making it easy to interface to it via Ruby.

You can read more about Vowpal Wabbit here: http://hunch.net/~vw/

## Installing

	gem install "bors"

or in your Gemfile

	gem 'bors'

As Bors is a wrapper around Vowpal Wabbit, you'll also need to install VW. The instructions on the tutorial page for VW are a great place to start: https://github.com/JohnLangford/vowpal_wabbit/wiki/Tutorial

## Step by step introduction

This introduction mirrors the step by step introduction on the VW tutorial page.

### Creating a dataset

	require 'bors'

	bors = Bors.new({:examples_file => "path/to/examples.txt"})

	bors.add_example({ :label => 0, :features => [{"price" => 0.23, "sqft" => 0.25, "age" => 0.05}, "2006"] })
	bors.add_example({ :label => 1, :importance => 2, :tag => "second_house", :features => [{"price" => 0.18, "sqft" => 0.15, "age" => 0.35}, "1976"] })
	bors.add_example({ :label => 0, :importance => 1, :prediction => 0.5, :tag => "third_house", :features => [{"price" => 0.53, "sqft" => 0.32, "age" => 0.87}, "1924"] })

Then process it for learning

	result = bors.run!

Bors will return a result object which can be inspected for more information:

	puts result.settings.to_h

Which will return information about the settings used for the run:

	{:num_weight_bits=>18, :learning_rate=>0, :initial_t=>0.0, :power_t=>0.5, :num_sources=>1}

You can also access a sample of the run and the results:

	puts result.sample.to_h
	puts result.results.to_h	

Examples are also automatically saved as you work.

If you want to work with an existing examples file, simply reinitialize the bors model pointing towards your text file.

	 Bors.new({:examples_file => "path/to/old_examples.txt"})

New examples added to the object will be added to the end of the file.

When you're happy with your examples and command line options, you can save your model/regressor into a file:

	bors.run!({:final_regressor => "~/tutorial_examples.model"})

Or just go ahead an generate predictions from your data:

	bors.run!({:predictions => "~/tutorial_examples.predictions"})

Finally, use an overfitted initial regressor to predict against the original results with, in training mode so no learning is done:

	bors.run!({:final_regressor => "~/tutorial_examples.model", :passes => 25})
	bors.run!({:initial_regressor => "~/tutorial_examples.model", :predictions => "~/tutorial_examples.predictions", :training_mode => true})

### Run Options

Bors supports automatic addition of runtime options implemented through Rubys method missing attribute. In other words, just set the command line options you would normally use on the object as a hash and they will be passed through.

	bors.run!({
		:training_mode => true,
		:create_cache => true,
		:cache_file => cache_path,
		:passes => 3,
		:initial_regressor => model_path,
		:predictions => predictions_path,
		:min_prediction => -1,
		:max_prediction => 1
	})

### VW Caches

At the moment caching is not supported from within the tool. You have the option to create caches at run time by calling the command line options as follows:

## Releases

### 0.0.1
* Added pass through support for Bors options. Not all options are supported yet (see the file lib/command_line.rb for support options) but it's not trivial to add more. This means that simply passing a hash of options when calling the Bors.new object will pass those options directly through to the command line. At the moment, the follow commands are supported with more to come very soon:

	* examples - (path to existing examples or where to create new)
	* cache_file - (path to existing cache file or where to create a new cache)
	* create_cache - (true / false to use a cache file)
	* passes
	* initial_regressor
	* final_regressor
	* predictions
	* min_prediction
	* max_prediction

* Removed inbuilt support of tempfiles and caches. It's assumed now that the program using the library will sort out how to use these files. Instead it is now a required option to pass a path through to a new or existing examples file location when creating a new Bors object. Likewise, you can pass in paths to cache files etc. See the tutorial above.

* Added a new option Bors.new({:temp_examples => true}) which will automatically delete the examples file after a run has been completed. Useful if you're building them temporarily from a database and don't want them hanging around.

## Coming soon / Todo

* Wrapper around the predictions output for easy reading of/iteration over it.
* "Getting" an example from the examples file should return an Example object instead of a String, but requires ability to parse VW formatted strings.
* Add more command line options.
* Add online modes / daemon communication wrapper.
* Automatic detection/use of cache files. Maybe.

## Contributing to Bors
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2012 Sam Richardson. See LICENSE.txt for
further details.