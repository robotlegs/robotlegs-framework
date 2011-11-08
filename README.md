# WARNING

Robotlegs 2 is under active development. Newcomers are encouraged to download the stable Robotlegs v1 release from: http://www.robotlegs.org/

# Welcome to Robotlegs 2!

This code is still a work in progress from two angles:

1. We're still nailing down the exact right api and expected behaviour.
2. We're still covering corner cases to test and implement the behaviour we choose.

## What's the eta for a beta?

It rather depends how many things the community come up with that we don't have covered, but hopefully we'll find that the API is a great fit with your needs, and we can proceed quickly to feature-stable alphas and betas.

Think weeks.

## What can I help with?

Functionality in Robotlegs 2 is 'built' rather than 'built-in'. This means that Robotlegs 1 favourites such as the MediatorMap and CommandMap are contained in their own packages.

The package structure is:

	extensions
		- someMap
			- api (interfaces and events)
			- impl (stuff to do the job)
			- SomeMapExtension (a file that 'installs' this extension into Robotlegs 2)
			

Note that we're using camelCase for the packages. We don't love it but it's the official adobe style and in the end we decided that it was easier to go with that prescription than to weight up the pros and cons of all our different style preferences.

### It's all about the tests

In the test package you'll find copious tests that show you what functionality is intended and has been ticked off.

You'll be our best friend if you do any of the following:

* Write implementation tests that could pick up corner cases, and can act as illustrations of the behaviour.
* Read our current tests and point out corner cases that need coverage.

## Start building examples soon

It's probably not worth building examples today, but by next week it should be possible to put together example projects which will help unveil holes and problems with the api.

## Start building extensions!

If you've got an existing RL1 extension or utility, get in touch and we'll put you on track to port it to Robotlegs 2. If you've got a new idea, let us know and we'll let you know whether it's something that can hang off of some of our core functionality, or whether you need to build from scratch, and we can give you guidance on how to get it to install in Robotlegs 2.

## Get involved in the conversation

We have spent a lot of time experimenting and following a few different paths to explore what Robotlegs 2 should be. We are by no means 100% certain of the current api or implementation - and we'd definitely like your input. Commit comments are particularly useful, and we'll also come up with a plan for enabling focussed discussion on each of the important topics.

---

## Building and Running the Tests on OS X

- Install XCode 3 or 4
- check RubyGems version
	
	$ gem -v
	1.8.1
	
- update RubyGems if version is less than 1.3.6

	$ sudo gem update --system
	
- install Bundler

	$ sudo gem install bundler
	
- run Bundler to install dependencies

	$ bundle install
	
- run Buildr to build RobotLegs & run Tests

	$ bundle exec buildr test
	
- open test report

	$ open reports/flexunit4/html/index.html
	
[Example output of this process](https://gist.github.com/1336238)


