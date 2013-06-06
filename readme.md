# Robotlegs

Robotlegs is an ActionScript application framework for Flash and Flex. It offers:

+ Dependency injection
+ Module management
+ Command management
+ View management
+ Plug-and-play extensions

## Download

http://www.robotlegs.org/

## Documentation & Support

The framework documentation exists as README files in the repository. The best way to read them is through GitHub:

[Documentation](https://github.com/robotlegs/robotlegs-framework/tree/master/src/robotlegs/bender)

[Support](http://knowledge.robotlegs.org/)

## Robotlegs 2 (What's New?)

+ The fluent API makes your code more readable
+ An extension mechanism makes the framework highly customizable
+ Bundles allow you to get applications started quickly
+ Lightweight, built-in logging shows you what the framework is doing
+ Mediators can be mapped to abstract types and interfaces
+ View processing has been significantly optimized
+ A context can process more than one display list (PopUp support)
+ Greatly simplified module (multi-context) support

[Change log](https://github.com/robotlegs/robotlegs-framework/blob/master/changelog.md)

# Quickstart

## Creating A Context

To create a Robotlegs application or module you need to instantiate a Context. A context won't do much without some configuration.

Plain ActionScript:

```as3
_context = new Context()
    .install(MVCSBundle)
    .configure(MyAppConfig, SomeOtherConfig)
    .configure(new ContextView(this));
```

We install the MVCSBundle, which in turn installs a number of commonly used Extensions. We then add some custom application configurations.

We pass the instance "this" through as the "contextView" which is required by many of the view related extensions. It must be installed after the bundle or it won't be processed. Also, it should always be added as the final configuration as it may trigger context initialization.

Note: You must hold on to the context instance or it will be garbage collected.

Flex:

```xml
<fx:Declarations>
    <rl2:ContextBuilder>
        <mvcs:MVCSBundle/>
        <config:MyAppConfig/>
    </rl2:ContextBuilder>
</fx:Declarations>
```

Note: In Flex we don't need to manually provide a "contextView" as the builder can determine this automatically.

[Framework](https://github.com/robotlegs/robotlegs-framework/tree/master/src/robotlegs/bender/framework)

## Context Initialization

If a ContextView is provided the Context is automatically initialized when the supplied view lands on stage. Be sure to install the ContextView last, as it may trigger context initialization.

If a ContextView is not supplied then the Context must be manually initialized.

```as3
_context = new Context()
    .install(MyCompanyBundle)
    .configure(MyAppConfig, SomeOtherConfig)
    .initialize();
```

Note: This does not apply to Flex MXML configuration as the ContextView is automatically determined and initialization will be automatic.

[ContextView](https://github.com/robotlegs/robotlegs-framework/tree/master/src/robotlegs/bender/extensions/contextView)

## Application & Module Configuration

A simple application configuration file might look something like this:

```as3
public class MyAppConfig implements IConfig
{
    [Inject]
    public var injector:IInjector;

    [Inject]
    public var mediatorMap:IMediatorMap;

    [Inject]
    public var commandMap:IEventCommandMap;

    [Inject]
    public var contextView:ContextView;

    public function configure():void
    {
        // Map UserModel as a context enforced singleton
        injector.map(UserModel).asSingleton();

        // Create a UserProfileMediator for each UserProfileView
        // that lands inside of the Context View
        mediatorMap.map(UserProfileView).toMediator(UserProfileMediator);

        // Execute UserSignInCommand when UserEvent.SIGN_IN
        // is dispatched on the context's Event Dispatcher
        commandMap.map(UserEvent.SIGN_IN).toCommand(UserSignInCommand);

        // The "view" property is a DisplayObjectContainer reference.
        // If this was a Flex application we would need to cast it
        // as an IVisualElementContainer and call addElement().
        contextView.view.addChild(new MainView());
    }
}
```

The configuration file above implements IConfig. An instance of this class will be created automatically when the context initializes.

We Inject the utilities that we want to configure, and add our Main View to the Context View.

[Framework](https://github.com/robotlegs/robotlegs-framework/tree/master/src/robotlegs/bender/framework)

### An Example Mediator

The mediator we mapped above might look like this:

```as3
public class UserProfileMediator extends Mediator
{
    [Inject]
    public var view:UserProfileView;

    override public function initialize():void
    {
        // Redispatch an event from the view to the framework
        addViewListener(UserEvent.SIGN_IN, dispatch);
    }
}
```

The view that caused this mediator to be created is available for Injection.

[MediatorMap](https://github.com/robotlegs/robotlegs-framework/tree/master/src/robotlegs/bender/extensions/mediatorMap)

### An Example Command

The command we mapped above might look like this:

```as3
public class UserSignInCommand extends Command
{
    [Inject]
    public var event:UserEvent;

    [Inject]
    public var model:UserModel;

    override public function execute():void
    {
        if (event.username == "bob")
            model.signedIn = true;
    }
}
```

The event that triggered this command is available for Injection.

[EventCommandMap](https://github.com/robotlegs/robotlegs-framework/tree/master/src/robotlegs/bender/extensions/eventCommandMap)

# Building and Running the Tests

## Requirements

Whilst Robotlegs can be used for Flex 3 & 4 and plain ActionScript projects, the library must be built with the Flex 4.6 SDK or above.

## Building with ANT

Copy the "user.properties.eg" file to "user.properties" and edit it to point to your local Flex SDK. Then run:

ant package

## Building with Maven

See: Maven-README

## Building with Buildr on OSX

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

# Robotlegs 1

The source for Robotlegs 1 can be found in the version1 branch:

[Robotlegs Version 1 Branch](https://github.com/robotlegs/robotlegs-framework/tree/version1)
