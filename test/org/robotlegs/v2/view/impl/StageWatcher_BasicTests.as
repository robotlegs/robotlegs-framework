//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
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

	public class StageWatcher_BasicTests
	{

		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/

		protected var container:DisplayObjectContainer;

		protected var group:UIComponent;

		protected var watcher:IViewWatcher;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

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
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function addHandler_should_run_when_view_lands_in_container():void
		{
			const result:HandlerResult = add_and_remove_view_and_return_result(0x1, 0x1, false);
			const addedHandlerRan:Boolean = result.addedCallCount == 1;
			assertThat(addedHandlerRan, isTrue());
		}

		[Test]
		public function adding_handler_twice_should_not_cause_handler_to_be_called_twice():void
		{
			const view:Sprite = new Sprite();
			var addedCallCount:int;
			const handler:ViewHandlerSupport = new ViewHandlerSupport(1, 1, false,
				function onAdded(view:DisplayObject, info:IViewClassInfo, response:uint):void
				{
					addedCallCount++;
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
		public function removeHandler_should_not_run_if_handler_didnt_handle_view():void
		{
			const result:HandlerResult = add_and_remove_view_and_return_result(0x1, 0x0, false);
			const removedHandlerRan:Boolean = result.removedCallCount > 0;
			assertThat(removedHandlerRan, isFalse());
		}

		[Test]
		public function removeHandler_should_only_run_if_handler_handled_view():void
		{
			const result:HandlerResult = add_and_remove_view_and_return_result(0x1, 0x1, false);
			const removedHandlerRan:Boolean = result.removedCallCount > 0;
			assertThat(removedHandlerRan, isTrue());
		}


		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function add_and_remove_view_and_return_result(interests:uint,
			interestsToActuallyHandle:uint = 0,
			blocking:Boolean = false):HandlerResult
		{
			const result:HandlerResult = new HandlerResult();
			const target:Sprite = new Sprite();
			const handler:ViewHandlerSupport = new ViewHandlerSupport(
				interests,
				interestsToActuallyHandle,
				blocking,
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
			container.addChild(target);
			container.removeChild(target);
			return result;
		}
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



