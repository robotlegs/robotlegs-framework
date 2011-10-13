//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.view.impl
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import mx.core.UIComponent;
	import org.flexunit.assertThat;
	import org.fluint.uiImpersonation.UIImpersonator;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;
	import org.robotlegs.v2.view.api.IViewClassInfo;
	import org.robotlegs.v2.view.api.IViewWatcher;
	import org.robotlegs.v2.view.impl.support.ViewHandlerSupport;

	public class StageWatcherTest
	{

		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/

		protected var container:DisplayObjectContainer;

		protected var group:UIComponent;

		protected var watcher:IViewWatcher;


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		[Test]
		public function addHandler_should_run_when_view_lands_in_container():void
		{
			const responses:Array =
				add_handlers_and_add_and_remove_view_and_return_results([
				new HandlerConfig(0x01, 1, false)
				]);
			const addedCalled:Boolean = HandlerResult(responses[0]).addedCallCount > 0;
			assertThat(addedCalled, isTrue());
		}

		[Test]
		public function adding_handler_twice_should_not_cause_handler_to_be_called_twice():void
		{
			const view:Sprite = new Sprite();
			var addedCallCount:int;
			var removedCalledCount:int;
			const handler:ViewHandlerSupport = new ViewHandlerSupport(1, 1, false,
				function onAdded(view:DisplayObject, info:IViewClassInfo, response:uint):void
				{
					addedCallCount++;
				},
				function onRemoved(view:DisplayObject):void
				{
					removedCalledCount++;
				});
			watcher.addHandler(handler, container);
			watcher.addHandler(handler, container);
			container.addChild(view);
			container.removeChild(view);
			assertThat(addedCallCount, equalTo(1));
		}

		[Test(expects='ArgumentError')]
		public function adding_handler_with_no_interests_should_throw_an_error():void
		{
			var handler:ViewHandlerSupport = new ViewHandlerSupport(0, 0, false, null, null);
			watcher.addHandler(handler, container);
		}

		[Test]
		public function bitmasking_should_work_as_expected():void
		{
			var combinedResponse:uint = 0;
			const interests:uint = uint(parseInt('0001', 2));
			const blockingResponse:uint = uint(parseInt('0011', 2));
			const skipFirst:Boolean = !((combinedResponse & 0xAAAAAAAA) ^ (interests << 1));
			combinedResponse |= blockingResponse;
			const skipSecond:Boolean = !((combinedResponse & 0xAAAAAAAA) ^ (interests << 1));
			assertThat(skipFirst, isFalse());
			assertThat(skipSecond, isTrue());
			// shift interest to form blocking interest			
			assertThat(0x000001 << 1, equalTo(0x000002));
			assertThat(0x000004 << 1, equalTo(0x000008));
		}

		[Test]
		public function first_blocking_handler_should_block_second_handler_when_interests_are_the_same():void
		{
			const responses:Array =
				add_handlers_and_add_and_remove_view_and_return_results([
				new HandlerConfig(1, 1, true),
				new HandlerConfig(1, 1, true)
				]);
			const secondHandlerAddedCalled:Boolean = HandlerResult(responses[1]).addedCallCount > 0;
			assertThat(secondHandlerAddedCalled, isFalse());
		}

		[Test]
		public function first_blocking_handler_should_not_block_second_handler_when_interests_are_different():void
		{
			const responses:Array =
				add_handlers_and_add_and_remove_view_and_return_results([
				new HandlerConfig(1, 1, true),
				new HandlerConfig(4, 4, true)
				]);
			const secondHandlerAddedCalled:Boolean = HandlerResult(responses[1]).addedCallCount > 0;
			assertThat(secondHandlerAddedCalled, isTrue());
		}

		[Test]
		public function first_nonBlocking_handler_should_not_block_second_handler_when_interests_are_the_same():void
		{
			const responses:Array =
				add_handlers_and_add_and_remove_view_and_return_results([
				new HandlerConfig(1, 1, false),
				new HandlerConfig(1, 1, false)
				]);
			const secondHandlerAddedCalled:Boolean = HandlerResult(responses[1]).addedCallCount > 0;
			assertThat(secondHandlerAddedCalled, isTrue());
		}

		[Test]
		public function removeHandler_should_not_run_if_handler_didnt_handle_view():void
		{
			const view:Sprite = new Sprite();
			var removedCalled:Boolean;
			const handler:ViewHandlerSupport = new ViewHandlerSupport(1, 0, false,
				function onAdded(view:DisplayObject, info:IViewClassInfo, response:uint):void
				{
				},
				function onRemoved(view:DisplayObject):void
				{
					removedCalled = true;
				});
			watcher.addHandler(handler, container);
			container.addChild(view);
			container.removeChild(view);
			assertThat(removedCalled, isFalse());

		}

		[Test]
		public function removeHandler_should_only_run_if_handler_handled_view():void
		{
			const view:Sprite = new Sprite();
			var removedCalled:Boolean;
			const handler:ViewHandlerSupport = new ViewHandlerSupport(1, 1, false,
				function onAdded(view:DisplayObject, info:IViewClassInfo, response:uint):void
				{
				},
				function onRemoved(view:DisplayObject):void
				{
					removedCalled = true;
				});
			watcher.addHandler(handler, container);
			container.addChild(view);
			container.removeChild(view);
			assertThat(removedCalled, isTrue());

		}

		[Test]
		public function removedHandler_should_run_when_view_leaves_container():void
		{
			const responses:Array =
				add_handlers_and_add_and_remove_view_and_return_results([
				new HandlerConfig(1, 1, false)
				]);
			const removedCalled:Boolean = HandlerResult(responses[0]).removedCallCount > 0;
			assertThat(removedCalled, isTrue());
		}

		[Before(ui)]
		public function setUp():void
		{
			group = new UIComponent()
			container = new Sprite();
			watcher = new StageWatcher();

			group.addChild(container)
			UIImpersonator.addChild(group);
		}

		[After]
		public function tearDown():void
		{
			watcher = null;
			UIImpersonator.removeAllChildren();
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function add_handlers_and_add_and_remove_view_and_return_results(handlerConfigs:Array):Array
		{
			const view:Sprite = new Sprite();

			const results:Array = handlerConfigs.map(function(... rest):HandlerResult
			{
				return new HandlerResult();
			}, this);

			handlerConfigs.forEach(function(config:HandlerConfig, index:int, ... rest):void
			{
				var result:HandlerResult = results[index];
				var handler:ViewHandlerSupport = new ViewHandlerSupport(
					config.interests,
					config.interestsToHandle,
					config.blocking,
					function onAdded(view:DisplayObject, info:IViewClassInfo, response:uint):void
					{
						result.addedCallCount++;
						result.response = response;
					},
					function onRemoved(view:DisplayObject):void
					{
						result.removedCallCount++;
					});
				watcher.addHandler(handler, container);
			}, this);

			container.addChild(view);
			container.removeChild(view);

			return results;
		}
	}
}

class HandlerConfig
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	public var blocking:Boolean;

	public var interests:uint;

	public var interestsToHandle:uint;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	public function HandlerConfig(interests:uint, interestsToHandle:uint, blocking:Boolean)
	{
		this.interests = interests;
		this.interestsToHandle = interestsToHandle;
		this.blocking = blocking;
	}
}

class HandlerResult
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	public var addedCallCount:uint;

	public var removedCallCount:uint;

	public var response:uint;
}
