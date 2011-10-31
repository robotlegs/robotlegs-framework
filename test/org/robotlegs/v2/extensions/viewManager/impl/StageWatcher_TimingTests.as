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
	import org.flexunit.assertThat;
	import org.fluint.uiImpersonation.UIImpersonator;
	import org.hamcrest.object.equalTo;
	import org.robotlegs.v2.extensions.viewManager.api.IContainerRegistry;
	import org.robotlegs.v2.extensions.viewManager.api.IViewClassInfo;
	import org.robotlegs.v2.extensions.viewManager.api.IViewProcessor;
	import org.robotlegs.v2.extensions.viewManager.api.IViewWatcher;
	import org.robotlegs.v2.extensions.viewManager.impl.support.ViewHandlerSupport;
	import org.robotlegs.v2.extensions.viewManager.utilities.watchers.AutoStageWatcher;

	public class StageWatcher_TimingTests
	{
		protected var container:DisplayObjectContainer;

		protected var containerRegistry:IContainerRegistry;

		protected var group:UIComponent;

		protected var viewProcessor:IViewProcessor;

		[Before(ui)]
		public function setUp():void
		{
			group = new UIComponent()
			container = new Sprite();
			containerRegistry = new ContainerRegistry();
			viewProcessor = new ViewProcessor(containerRegistry);
			group.addChild(container)
			UIImpersonator.addChild(group);
		}

		[After]
		public function tearDown():void
		{
			UIImpersonator.removeAllChildren();
		}

		[Test]
		public function watcher_added_after_container_should_still_respond():void
		{

			const view:Sprite = new Sprite();
			var addedCallCount:int;
			const handler:ViewHandlerSupport = new ViewHandlerSupport(1, 1, false,
				function onAdded(view:DisplayObject, info:IViewClassInfo, response:uint):void
				{
					addedCallCount++;
				});
			viewProcessor.addHandler(handler, container);
			var viewWatcher:IViewWatcher = new AutoStageWatcher(containerRegistry);
			viewWatcher.configure(viewProcessor);
			container.addChild(view);
			container.removeChild(view);
			assertThat(addedCallCount, equalTo(1));
			viewWatcher.destroy();
		}
	}
}
