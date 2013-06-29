# Robotlegs Framework Changelog:

## Robotlegs 2

### v2.1.0

EventMap - opens up routeEventToListener

Fixes RobotlegsInjector.createChild() bug

### v2.0.0

A brand new day.

### v2.0.0b8

Breaking change: Introduces IInjector

Fix: Change your injector references from Injector to IInjector

### v2.0.0b7

Adds ViewProcessorMap to MVCS bundle

Adds context Lifecycle Event relaying to the EventDispatcher Extension

Adds Module Connector - for easy event relaying between modules

Removes ScopedEventDispatcherExtension - replaced by Module Connector

Removes MessageDispatcher related extensions

### v2.0.0b6

Ensures that certain extensions can only be installed before context initialization.

Removes Hamcrest dependency from framework. Replaced with custom IMatcher.

Complete Command Center revamp.

Introduces DirectCommandMap (experimental).

### v2.0.0b5

Fixes #109 (mediator autoRemove)

Fixes #110 (Event Command Map bug)

Fixes #112 (Modularity issues)

Fixes #113 (naughty PreDestroy)

Detain and Release events dispatched by context (Issue #104)

Switches back to official Swiftsuspenders build (v2.0.0rc2)

### v2.0.0b4

Modularity timing fix.

Introduces StageCrawler Extension. This extension scans for view components that are already on stage when the context initializes.

### v2.0.0b3

*Lifecycle*

Important: The lifecycle getter has been removed from the Context. Instead, the Lifecycle API methods have been added to the Context directly.

So, context.lifecycle.whenInitializing(callback) is now simply context.whenInitializing(callback)

Adds Vigilance Extension to MVCS Bundle

MVCS Bundle sets the LogLevel to DEBUG

Lifecycle dispatches stateChange event

Adds uninitialized getter to ILifecycle

Adds addChild() and removeChild() to IContext

### v2.0.0b2

Asdocs

EventCommandMap optimisations

### v2.0.0b1

Robotlegs 2 public beta

## Robotlegs 1

### v1.5.2

Fixed: https://github.com/robotlegs/robotlegs-framework/issues/25

### v1.5.1

Fixed: https://github.com/robotlegs/robotlegs-framework/issues/24

### v1.5.0

*CommandMap Abstract Event Injection*

For event-triggered commands the event is now also mapped to "Event". For example:

[Inject] public var abstractEvent:Event;

[Inject] public var concreteEvent:SomeEvent;

*MVCS Mediator*

Added syntactic sugar methods removeViewListener() and removeContextListener()

*SwiftSuspenders*

Updated SwiftSuspenders to v1.6.0

### v1.4.0

*ViewMap & MediatorMap*

contextView stage listener optimizations.

*MediatorMap*

Added IMediatorMap#hasMapping(viewClassOrName:*):Boolean;

### v1.3.0

*ApplicationDomain*

Added applicationDomain getter/setter to IInjector to help with Application Domains.

### v1.2.0

*MediatorMap.mapType*

The injectViewAs parameter is changed from expecting a Class to expecting a Class or an Array of Classes.

### v1.1.2

*ASDocs*

Build script updated to bundle ASDocs into SWC for inline display in Flash Builder 4. Build needs to be run against Flex SDK 4.x

### v1.1.1

*Mediator*

Fixed: http://github.com/robotlegs/robotlegs-framework/issues/#issue/6

### v1.1.0

*SwiftSuspenders*

Updated SwiftSuspenders to v1.5.1

PLEASE NOTE: mapValue no longer injects into the value instance - the old behaviour was incorrect.

*Injector*

Added IInjector#hasMapping(clazz:Class, named:String = ""):Boolean;

Added IInjector#getInstance(clazz:Class, named:String = ""):*;

Added IInjector#createChild():IInjector;

*CommandMap*

Added ICommandMap#execute(commandClass:Class, payload:Object = null, payloadClass:Class = null, named:String = ''):void

Added ICommandMap#unmapEvents() - unmaps all event mappings

Added ICommandMap#detain() and release() - enables Async Commands

*Mediator*

Added mvcs.Mediator EventMap Sugar: addViewListener() and addContextListener()

*Misc*

mvcs.Context: CommandMap and MediatorMap are handed child injectors - to enable non-destructive temporary mappings.

Deprecated IContextProvider

### v1.0.3

Fixed: http://github.com/robotlegs/robotlegs-framework/issues#issue/2

### v1.0.2

Fixed: http://github.com/robotlegs/robotlegs-framework/issues#issue/2

### v1.0.1

Updated SwiftSuspenders to v1.0.1

### v1.0.0

Whammo, and the Robot has Legs. We managed to avoid hitting double digits for the RCs!

### v1.0RC9

Fixes to SwiftSuspenders

### v1.0RC8

Added IMediatorMap.unmapType()

### v1.0RC7

ViewMap.mapClass() changed to ViewMap.mapType()

### v1.0RC6

Internal changes: ContextBase cleaned up - initialize() removed. Overriding the default apparatus:

    public function MyContext()
    {
	    injector = new SwiftSuspendersInjector(xmlConfig);
	    super();
    }

### v1.0RC4/5

Fixes to SwiftSuspenders

### v1.0RC3

Removed nometa package

### v1.0RC2

CommandMap Bug fix

### v1.0RC1

No changes

### v0.9.8 - Untitled4

Removed ICommand

*MediatorMap*

Merged MediatorMap#mapModule into MediatorMap#mapType

New view mapping signature

mapType(viewClassOrName:*, mediatorClass:Class, injectViewAs:Class = null, autoCreate:Boolean = true, autoRemove:Boolean = true):void

### v0.9.7 - XtensibleMixdownLoafers

Enabled XML configuration of injection points

### v0.9.6 - PanelBeaten

Added the dispatch() helper method back to mvcs actors

Removed named injection points

*MediatorMap*

Enabled automatic creation of mediator for contextView if mapped

*ContextBase*

Made all ContextBase constructor arguments optional to enable declarative (mxml) Context instantiation

*Nometa*

Introduced Nometa implementation

*Actor*

Unified Model and Service into Actor
Removed Model
Removed Service

*EventMap*

Added strong event mapping to EventMap

*CommandMap*

Re-ordered the mapping arguments

From: mapEvent(commandClass:Class, eventType:String, eventClass:Class = null, oneshot:Boolean = false):void

To: mapEvent(eventType:String, commandClass:Class, eventClass:Class = null, oneshot:Boolean = false):void

### v0.9.5 - BigMistake2

Removed dispatchEvent() helper method - Again, really sorry about that little mixup there

*Mediator*

addEventListenerTo() becomes eventMap.mapListener()

### v0.9.4 - WhatProxyWhere?

Proxy renamed to Model

### v0.9.3 - Untitled3

CommandMap bugfix

### v0.9.2 - Untitled2

No changes!

### v0.9.1 - BigMistake1

dispatch() helper method renamed to dispatchEvent()

### v0.9 - ElasticChaos

Removed "as3commons-logging":http://www.as3commons.org/

Removed EventBroadcaster

MediatorFactory renamed to MediatorMap

CommandFactory renamed to CommandMap

IInjector.bind* renamed to IInjector.map*

*ICommandMap*

CommandMap now accepts optional Event class parameter for stronger mapping.

The argument order had to be re-arranged so that the optional eventClass would come after the mandatory commandClass.

From: mapEvent(type:String, commandClass:Class, oneshot:Boolean = false):void;

To: mapEvent(commandClass:Class, eventType:String, eventClass:Class = null, oneshot:Boolean = false):void;

*Constructor Injection*

Changed all automated instantiation to use IInjector#instantiate to enable constructor injection, changed DI adapters accordingly and added new SwiftSuspenders support constructor injection

*Bonus Adapters Removed*

Removed Spring Action Script and SmartyPants-IOC adapters (they can be installed separately)

### v0.8.1 - SwiftyPants

Added adapters for "SwiftSuspenders":http://github.com/tschneidereit/SwiftSuspenders

### v0.8 - ByeByeFlex

FlexMediator decoupled from Flex and merged into Mediator

Removed FlexMediator

### v0.7 - ShortWave

Added dispatch() helper method

### v0.6 - Untitled1

Introduced "as3commons-logging":http://www.as3commons.org/

### v0.5.2 - TheRegister

IMediator.onRegisterComplete renamed to IMediator.onRegister

### v0.4 - OrganDonor

net.boyblack.robotlegs.* renamed to org.robotlegs.*

### v0.3 - ElastoBoot

Added Spring ActionScript adapters

Provided adapters: "SmartyPants-IOC":http://smartypants.expantra.net/

Provided adapters: "SpringActionScript":http://www.springactionscript.org/

### v0.2 - ReversiblePants

Introduced DI and reflection adapters

Provided adapters: "SmartyPants-IOC":http://smartypants.expantra.net/

### v0.1

Proof-of-concept prototype
