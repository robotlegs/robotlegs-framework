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
			const addedWasCalled:Boolean = add_and_remove_view_and_return_results().addedWasCalled;
			assertThat(addedWasCalled, isTrue());
		}

		[Test(expects='ArgumentError')]
		public function adding_handler_with_no_interests_should_throw_an_error():void
		{
			var handler:ViewHandlerSupport = new ViewHandlerSupport(0, false, null, null);
			watcher.addHandler(handler, container);
		}

		[Test]
		public function bitmasking_should_work_as_expected():void
		{
			var combinedResponse:uint = 0;
			const BLOCKING_MASK:uint = uint(parseInt('10101010101010101010101010101010', 2));
			const interests:uint = uint(parseInt('00000000000000000000000000000001', 2));
			const response:uint = uint(parseInt('00000000000000000000000000000011', 2));
			const skipFirst:Boolean = !((combinedResponse & BLOCKING_MASK) ^ (interests << 1));
			combinedResponse |= response;
			const skipSecond:Boolean = !((combinedResponse & BLOCKING_MASK) ^ (interests << 1));
			assertThat(skipFirst, isFalse());
			assertThat(skipSecond, isTrue());
		}

		[Test]
		public function first_blocking_handler_should_prevent_second_interested_handler_from_being_called():void
		{
			const blocking:Boolean = true;
			const secondHandlerAddedCalled:Boolean =
				add_two_handlers_and_add_and_remove_view_and_return_results(1, 1, blocking, blocking).secondHandlerAddedCalled;
			assertThat(secondHandlerAddedCalled, isFalse());
		}

		[Test]
		public function removedHandler_should_run_when_view_leaves_container():void
		{
			const removedWasCalled:Boolean = add_and_remove_view_and_return_results().removedWasCalled;
			assertThat(removedWasCalled, isTrue());
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

		private function add_and_remove_view_and_return_results():Object
		{
			const view:Sprite = new Sprite();
			var addedWasCalled:Boolean;
			var removedWasCalled:Boolean;
			var handler:ViewHandlerSupport = new ViewHandlerSupport(1, false,
				function onAdded(view:DisplayObject, info:IViewClassInfo):void
				{
					addedWasCalled = true;
				},
				function onRemoved(view:DisplayObject):void
				{
					removedWasCalled = true;
				});
			watcher.addHandler(handler, container);
			container.addChild(view);
			container.removeChild(view);
			return {
					addedWasCalled: addedWasCalled,
					removedWasCalled: removedWasCalled
				};
		}

		private function add_two_handlers_and_add_and_remove_view_and_return_results(interests1:uint, interests2:uint, blocking1:Boolean, blocking2:Boolean):Object
		{
			const view:Sprite = new Sprite();
			var firstHandlerAddedCalled:Boolean;
			var firstHandlerRemovedCalled:Boolean;
			var handler1:ViewHandlerSupport = new ViewHandlerSupport(interests1, blocking2,
				function onAdded(view:DisplayObject, info:IViewClassInfo):void
				{
					firstHandlerAddedCalled = true;
				},
				function onRemoved(view:DisplayObject):void
				{
					firstHandlerRemovedCalled = true;
				});
			var secondHandlerAddedCalled:Boolean;
			var secondHandlerRemovedCalled:Boolean;
			var handler2:ViewHandlerSupport = new ViewHandlerSupport(interests2, blocking2,
				function onAdded(view:DisplayObject, info:IViewClassInfo):void
				{
					secondHandlerAddedCalled = true;
				},
				function onRemoved(view:DisplayObject):void
				{
					secondHandlerRemovedCalled = true;
				});
			watcher.addHandler(handler1, container);
			watcher.addHandler(handler2, container);
			container.addChild(view);
			container.removeChild(view);
			return {
					firstHandlerAddedCalled: firstHandlerAddedCalled,
					firstHandlerRemovedCalled: firstHandlerRemovedCalled,
					secondHandlerAddedCalled: secondHandlerAddedCalled,
					secondHandlerRemovedCalled: secondHandlerRemovedCalled
				};
		}
	}
}
