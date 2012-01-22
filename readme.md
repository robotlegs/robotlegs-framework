# WARNING

Robotlegs 2 is under active development. Developers are encouraged to download the stable Robotlegs v1 release from: http://www.robotlegs.org/

The source for Robotlegs 1 can be found in the master branch:

https://github.com/robotlegs/robotlegs-framework/tree/master

# Note For Extension Authors

Extensions have changed. Please see: robotlegs.bender.extensions

# Robotlegs

Robotlegs is an Action Script application framework for Flash and Flex. It offers:

+ Dependency configuration
+ Dependency injection
+ Module management
+ Command management
+ View management

# Robotlegs v2 - What's New?

Robotlegs 2 is a complete rewrite of the Robotlegs framework. It features:

+ Better configuration
+ Better extension
+ Flexible type matching

# Robotlegs v1 vs v2

## RL1 Design Priorities

1. Small
2. Fast

## RL2 Design Priorities

1. Flexible
2. Small
3. Fast


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


