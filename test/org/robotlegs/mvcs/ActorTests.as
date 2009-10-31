/*
 * Copyright (c) 2009 the original author or authors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
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
