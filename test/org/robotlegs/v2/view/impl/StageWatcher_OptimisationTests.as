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
	import org.fluint.uiImpersonation.UIImpersonator;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.robotlegs.v2.view.api.IViewClassInfo;
	import org.robotlegs.v2.view.api.IViewWatcher;
	import org.robotlegs.v2.view.impl.support.ViewHandlerSupport;

	public class StageWatcher_OptimisationTests
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
		public function a_handler_that_doesnt_handle_a_view_SHOULD_be_reconsulted_after_invalidation():void
		{
			var addedCallCount:int;
			const handler:ViewHandlerSupport = new ViewHandlerSupport(
				0x1,
				0x0,
				false,
				function onAdded(view:DisplayObject, info:IViewClassInfo, response:uint):void
				{
					addedCallCount++;
				});
			watcher.addHandler(handler, container);
			container.addChild(new Sprite());
			container.addChild(new Sprite());
			handler.invalidate();
			container.addChild(new Sprite());
			container.addChild(new Sprite());
			assertThat(addedCallCount, equalTo(2));
		}

		[Test]
		public function a_handler_that_doesnt_handle_a_view_SHOULD_be_reconsulted_if_a_new_handler_is_added():void
		{
			var addedCallCount:int;
			const handler:ViewHandlerSupport = new ViewHandlerSupport(
				0x1,
				0x0,
				false,
				function onAdded(view:DisplayObject, info:IViewClassInfo, response:uint):void
				{
					addedCallCount++;
				});
			watcher.addHandler(handler, container);
			container.addChild(new Sprite());
			container.addChild(new Sprite());
			watcher.addHandler(new ViewHandlerSupport(0x1), container);
			container.addChild(new Sprite());
			container.addChild(new Sprite());
			assertThat(addedCallCount, equalTo(2));
		}

		[Test]
		public function a_handler_that_doesnt_handle_a_view_should_NOT_be_consulted_for_that_view_class_again():void
		{
			var addedCallCount:int;
			const handler:ViewHandlerSupport = new ViewHandlerSupport(
				0x1,
				0x0,
				false,
				function onAdded(view:DisplayObject, info:IViewClassInfo, response:uint):void
				{
					addedCallCount++;
				});
			watcher.addHandler(handler, container);
			container.addChild(new Sprite());
			container.addChild(new Sprite());
			container.addChild(new Sprite());
			assertThat(addedCallCount, equalTo(1));
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
	}
}
