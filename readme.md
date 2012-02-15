# WARNING

Robotlegs 2 is under active development. Developers are encouraged to download the stable Robotlegs 1 release from: http://www.robotlegs.org/

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

# Quickstart

## Creating A Context

To create a Robotlegs application or module you need to instantiate a Context. A context won't do much without some configuration.

Plain ActionScript:

    _context = new Context(
        ClassicRobotlegsBundle,
        MyAppConfig,
        this);

Note: We pass the instance "this" through to the context. It will be used as the "contextView" which is required by many of the view related extensions. It must be installed after the bundle or it won't be processed. Also, you must hold on the the context instance or it will be garbage collected.

Flex:

    <fx:Declarations>
        <rl2:ContextBuilder>
            <classic:ClassicRobotlegsBundle/>
            <config:MyAppConfig/>
        </rl2:ContextBuilder>
    </fx:Declarations>

Note: In Flex we don't need to manually provide a "contextView" as the builder can determine this automatically.

## Application & Module Configurations

A simple configuration might look something like this:

    public class MyAppConfig
    {
        public function MyAppConfig(mediatorMap:IMediatorMap)
        {
            mediatorMap.mapView(SomeView).toMediator(SomeMediator);
        }
    }

Note: The configuration is a plain class. An instance of this class will be created automatically when the context initializes.

# Robotlegs 2 - What's New?

Robotlegs 2 is a complete rewrite of the Robotlegs framework. It features:

+ Better configuration
+ Better extension
+ Better module support
+ Flexible type matching

# Robotlegs 1 vs Robotlegs 2

## RL1 Design Priorities

1. Small
2. Fast

## RL2 Design Priorities

1. Flexible
2. Small
3. Fast

# Building and Running the Tests on OS X

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


