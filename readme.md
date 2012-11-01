# WARNING

Robotlegs 2 is under active development. Developers are encouraged to download the stable Robotlegs 1 release from: http://www.robotlegs.org/

The source for Robotlegs 1 can be found in the version1 branch:

https://github.com/robotlegs/robotlegs-framework/tree/version1

# Robotlegs

Robotlegs is an ActionScript application framework for Flash and Flex. It offers:

+ Dependency management
+ Module management
+ Command management
+ View management

# Quickstart

## Creating A Context

To create a Robotlegs application or module you need to instantiate a Context. A context won't do much without some configuration.

Plain ActionScript:

    _context = new Context()
        .extend(MVCSBundle)
        .configure(MyAppConfig, SomeOtherConfig)
        .configure(this);

Note: We pass the instance "this" through to the context. It will be used as the "contextView" which is required by many of the view related extensions. It must be installed after the bundle or it won't be processed. Also, it should be added as the final configuration as it may trigger context initialization.

Note: You must hold on to the context instance or it will be garbage collected.



Flex:

    <fx:Declarations>
        <rl2:ContextBuilder>
            <mvcs:MVCSBundle/>
            <config:MyAppConfig/>
        </rl2:ContextBuilder>
    </fx:Declarations>

Note: In Flex we don't need to manually provide a "contextView" as the builder can determine this automatically.

## Application & Module Configuration

A simple configuration might look something like this:

    public class MyAppConfig
    {
        public function MyAppConfig(mediatorMap:IMediatorMap)
        {
            mediatorMap.mapType(SomeView).toMediator(SomeMediator);
        }
    }

The configuration file above is a plain class. An instance of this class will be created automatically when the context initializes. Notice that we are using constructor injection to gain access to the mediator map inside our constructor.

WARNING: The config above will not work when using declarative configuration in Flex. For Flex configs that you intend to add directly to the ContextBuilder you have to use setter injection.. Read on.

If you want to use setter injection you must use a [PostConstruct] tag in your config to ensure that all your dependencies have been injected before you start interacting with them:

    public class MyAppConfig
    {
        [Inject]
        public var mediatorMap:IMediatorMap;

        [PostConstruct]
        public function init():void
        {
            // OK, ready to rock
            mediatorMap.mapView(SomeView).toMediator(SomeMediator);
        }
    }

Dependencies supplied via setter injection are not available until *after* construction, and attempting to access them will result in Null Pointer exceptions. This is *wrong*:

    public class MyErroneousAppConfig
    {
        [Inject]
        public var mediatorMap:IMediatorMap;

        public function MyErroneousAppConfig()
        {
            // ERROR: the mediatorMap property will not have been set yet!
            mediatorMap.mapView(SomeView).toMediator(SomeMediator);
        }
    }

# Reading The Source

Start here:

+ src/robotlegs/readme

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

# Building and Running the Tests

## Requirements

Whilst Robotlegs can be used for Flex 3 & 4 and plain ActionScript projects, the library must be built with the Flex 4.6 SDK or above.

## Using ANT

ant package

## Using Ruby on OSX

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


