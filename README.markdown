RobotLegs AS3
=============

RobotLegs AS3 is an event driven MVCS micro-architecture for Flash and Flex applications. It is inspired by the excellent PureMVC framework, but uses Dependency Injection to do away with Singletons, Services Locators and Casting, and provides automatic Mediator registration for View Components.

Currently, RobotLegs makes use of SmartyPantsIOC - an AS3 Dependency Injection framework for Flash and Flex.

No casting! No fetching! No Singletons! You can read more about it on my [blog](http://shaun.boyblack.co.za/blog/robotlegs-as3/).

Installation
------------

**Flex/FlashBuilder:**

Drop RobotLegsLib.swc and SmartyPantsIOC.swc into your "libs" folder.

If you are building a plain ActionScript project you might need to create the "libs" folder manually:

Right click the project, and create a New Folder called "libs".
Right click the project, open "properties", "Flex Build Path", "Library path", and add the folder "libs".

**Other IDEs or Editors:**

Include RobotLegsLib.swc and SmartyPantsIOC.swc in your build path.

Usage
-----

**Facade/Context**

RobotLegs does not make use of the Facade design pattern - instead there is something known as a Context. It's not really the same thing, and is only used to bootstrap your application.

Typically, when starting a new project, you extend the default Context, provide Dependency Injection and Reflection adapters, and override the startup() method.

Inside the startup() method you bind a couple of Commands to a startup event and then dispatch that event.

    [actionscript]
    public class HelloFlexContext extends Context
    {
      public function HelloFlexContext( contextView:DisplayObjectContainer )
      {
        super( contextView, new SmartyPantsInjector(), new SmartyPantsReflector() );
      }

      override public function startup():void
      {
        commandFactory.mapCommand( ContextEvent.STARTUP, PrepModelCommand, true );
        commandFactory.mapCommand( ContextEvent.STARTUP, PrepControllerCommand, true );
        commandFactory.mapCommand( ContextEvent.STARTUP, PrepServicesCommand, true );
        commandFactory.mapCommand( ContextEvent.STARTUP, PrepViewCommand, true );
        commandFactory.mapCommand( ContextEvent.STARTUP, StartupCommand, true );
        eventBroadcaster.dispatchEvent( new ContextEvent( ContextEvent.STARTUP ) );
      }
    }


By default, a Context will auto-Start when it's View Compontent is added to the Stage.


**Commands**

RobotLegs make use of native Flash Player events for framework communication. Much like PureMVC, Commands can be bound to events.

No parameters are passed to a Command's execute method however. Instead, you define the concrete event that will be passed to the Command as a dependency. This relieves you from having to cast the event.

Multiple Commands can be bound to an event type. They will be executed in the order that they were mapped. This is very handy for mapping your startup commands.

**Mediators**

RobotLegs makes it easy to work with deeply-nested, lazily-instantiated View Components.

You map Mediator classes to View Component classes during startup, or at runtime, and RobotLegs creates and registers Mediator instances automatically as View Components arrive on the stage.

A Mediator is only ready to be interacted with when it's onRegisterComplete method gets called. This is where you should register your listeners.

The default Mediator implementation provides a handy utility method called addEventListenerTo(). You should use this method to register listeners in your Mediator. Doing so allows RobotLegs to automatically remove any listeners when a Mediator gets removed.


NOTE: Flex Mediators should extend the FlexMediator Class.

Links
-----
- [Wiki](http://wiki.github.com/darscan/robotlegs)
- [Library Source](http://github.com/darscan/robotlegs/tree/master)
- [Demo Source](http://github.com/darscan/robotlegsdemos/tree/master)
- [Demo Flex App](http://shaun.boyblack.co.za/flash/robotlegsdemo/HelloFlex.html)
- [Issue Tracking](http://github.com/darscan/robotlegs/issues)
- [Discussion Group](http://groups.google.com/group/robotlegs)
- [Announcement](http://shaun.boyblack.co.za/blog/2009/04/16/robotlegs-an-as3-mvcs-framework-for-flash-and-flex-applications-inspired-by-puremvc/)
- [SmartyPants IOC](http://code.google.com/p/smartypants-ioc/)

License
-------

Copyright (c) 2009 BoyBlack.co.za

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is furnished
to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
