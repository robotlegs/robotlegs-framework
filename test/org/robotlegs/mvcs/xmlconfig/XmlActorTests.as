/*
 * Copyright (c) 2009 the original author or authors
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.robotlegs.mvcs.xmlconfig
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	import org.fluint.uiImpersonation.UIImpersonator;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.mvcs.support.TestActor;
	import org.robotlegs.mvcs.xmlconfig.support.TestContext;
	import org.robotlegs.mvcs.support.TestContextView;
	import org.robotlegs.mvcs.ActorTests;
	
	public class XmlActorTests extends org.robotlegs.mvcs.ActorTests
	{
		[Before(ui)]
		override public function runBeforeEachTest():void
		{
			contextView = new TestContextView();
			context = new TestContext(contextView);
			actor = new TestActor()
			injector = context.getInjector()
			UIImpersonator.addChild(contextView);
			injector.injectInto(actor);
		}
	}
}
