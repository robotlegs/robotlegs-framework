/*
 * Copyright (c) 2009 the original author or authors
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.robotlegs.mvcs
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	import org.fluint.uiImpersonation.UIImpersonator;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.mvcs.support.TestActor;
	import org.robotlegs.mvcs.support.TestContext;
	import org.robotlegs.mvcs.support.TestContextView;
	
	public class ActorTests
	{
		public static const TEST_EVENT:String = "testEvent";
		
		protected var context:TestContext;
		protected var contextView:DisplayObjectContainer;
		protected var actor:TestActor;
		protected var injector:IInjector;
		protected var eventDispatcher:IEventDispatcher;
		
		[BeforeClass]
		public static function runBeforeEntireSuite():void
		{
		}
		
		[AfterClass]
		public static function runAfterEntireSuite():void
		{
		}
		
		[Before(ui)]
		public function runBeforeEachTest():void
		{
			contextView = new TestContextView();
			context = new TestContext(contextView);
			actor = new TestActor()
			injector = context.getInjector()
			UIImpersonator.addChild(contextView);
			injector.injectInto(actor);
		}
		
		[After(ui)]
		public function runAfterEachTest():void
		{
			UIImpersonator.removeAllChildren();
		}
		
		[Test]
		public function hasEventDispatcher():void
		{
			Assert.assertNotNull(actor.eventDispatcher);
		}
		
		[Test(async)]
		public function canDispatchEvent():void
		{
			Assert.assertNotNull(actor.eventDispatcher);
			Async.handleEvent(this, context, TEST_EVENT, handleEventDispatch, 3000);
			actor.dispatchTestEvent();
		}
		
		private function handleEventDispatch(event:Event, param:*):void
		{
			Assert.assertEquals(event.type, TEST_EVENT);
		}
	}
}
