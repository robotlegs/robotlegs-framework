//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.viewManager.impl
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import mx.core.UIComponent;
	import org.fluint.uiImpersonation.UIImpersonator;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.robotlegs.v2.extensions.viewManager.api.IViewClassInfo;
	import org.robotlegs.v2.extensions.viewManager.api.IViewListener;
	import org.robotlegs.v2.extensions.viewManager.impl.support.ViewHandlerSupport;
	import org.robotlegs.v2.extensions.viewManager.integration.listeners.AutoStageListener;

	public class ViewManager_OptimisationTests
	{

		protected var container:DisplayObjectContainer;

		protected var containerRegistry:ContainerRegistry;

		protected var group:UIComponent;

		protected var viewProcessor:ViewProcessor;

		protected var viewWatcher:IViewListener;

		[Before(ui)]
		public function setUp():void
		{
			group = new UIComponent()
			container = new Sprite();
			containerRegistry = new ContainerRegistry();
			viewProcessor = new ViewProcessor(containerRegistry);
			viewWatcher = new AutoStageListener(viewProcessor, containerRegistry);

			group.addChild(container)
			UIImpersonator.addChild(group);
		}

		[After]
		public function tearDown():void
		{
			viewWatcher.destroy();
			UIImpersonator.removeAllChildren();
		}

		[Test]
		public function a_handler_that_doesnt_handle_a_view_SHOULD_be_reconsulted_after_processor_invalidation():void
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
			viewProcessor.addHandler(handler, container);
			container.addChild(new Sprite());
			container.addChild(new Sprite());
			handler.invalidate();
			container.addChild(new Sprite());
			container.addChild(new Sprite());
			assertThat(addedCallCount, equalTo(2));
		}

		[Test]
		public function a_handler_that_doesnt_handle_a_view_SHOULD_be_reconsulted_after_watcher_invalidation():void
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
			viewProcessor.addHandler(handler, container);
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
			viewProcessor.addHandler(handler, container);
			container.addChild(new Sprite());
			container.addChild(new Sprite());
			viewProcessor.addHandler(new ViewHandlerSupport(0x1), container);
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
			viewProcessor.addHandler(handler, container);
			container.addChild(new Sprite());
			container.addChild(new Sprite());
			container.addChild(new Sprite());
			assertThat(addedCallCount, equalTo(1));
		}
	}
}
