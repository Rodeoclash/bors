# Bors

> "One rabbit stew coming right up!"

## Introduction

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

	bors = Bors.new

	bors.add_example({ :label => 0, :features => [{"price" => 0.23, "sqft" => 0.25, "age" => 0.05}, "2006"] })
	bors.add_example({ :label => 1, :importance => 2, :tag => "second_house", :features => [{"price" => 0.18, "sqft" => 0.15, "age" => 0.35}, "1976"] })
	bors.add_example({ :label => 0, :importance => 1, :prediction => 0.5, :tag => "third_house", :features => [{"price" => 0.53, "sqft" => 0.32, "age" => 0.87}, "1924"] })

Then process it for learning

	result = bors.run

Bors will return a result object which can be inspected for more information:

	puts result.settings.to_h

Which will return information about the settings used for the run:

	{:num_weight_bits=>18, :learning_rate=>0, :initial_t=>0.0, :power_t=>0.5, :num_sources=>1}

You can also access a sample of the run and the results:

	puts result.sample.to_h
	puts result.results.to_h	

At this point, you might want to save your examples into a file so you can use them again later:

	@bors.save_examples("~/examples.txt")

You can load the examples again later and they will be reparsed into the internal format:

	@bors.load_examples("~/examples.txt") # NOTE - This has not been implemented yet

Either saving or loading a file which switch Bors from using an internal temp file to store examples to the file you have designated. In loading or saving a file, any new examples added will be added to the file you've just loaded/saved.

### VW Caches

VW supports caching of the example text files, this reduces space, improves the speed of loading examples when running VW and allows certain functionality like multiple passes over the data. The downside is that Bors cannot read/write to the cached files. Caches can created:

	@bors.create_cache("~/examples.cache")

or loaded:

	@bors.load_cache("~/examples.cache")

Some run options on VW (like "passes") will also create a cache file before running. Once Bors is using a cache, it is impossible to add further examples. It's suggested that you save your examples out to a file before entering the cache mode.

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