//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager.impl
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import mx.core.UIComponent;
	import org.flexunit.assertThat;
	import org.fluint.uiImpersonation.UIImpersonator;
	import org.hamcrest.object.equalTo;
	import robotlegs.bender.extensions.viewManager.support.CallbackViewHandler;

	public class ConfigureViewObserverTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var container:UIComponent;

		private var container2:UIComponent;

		private var registry:ContainerRegistry;

		private var observer:ManualStageObserver;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before(async, ui)]
		public function before():void
		{
			container = new UIComponent();
			container2 = new UIComponent();
			registry = new ContainerRegistry();
			observer = new ManualStageObserver(registry);
			UIImpersonator.addChild(container);
			UIImpersonator.addChild(container2);
		}

		[After(async, ui)]
		public function after():void
		{
			UIImpersonator.removeChild(container);
			observer.destroy();
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function view_is_handled_when_event_is_dispatched():void
		{
			const expected:Sprite = new Sprite();
			var actual:DisplayObject = null;
			registry
				.addContainer(container)
				.addHandler(new CallbackViewHandler(function(view:DisplayObject, type:Class):void {
					actual = view;
				}));
			container.addChild(expected);
			expected.dispatchEvent(new ConfigureViewEvent(ConfigureViewEvent.CONFIGURE_VIEW));
			assertThat(actual, equalTo(expected));
		}

		[Test]
		public function view_is_handled_when_added_somewhere_inside_container():void
		{
			const expected:Sprite = new Sprite();
			var actual:DisplayObject = null;
			registry
				.addContainer(container)
				.addHandler(new CallbackViewHandler(function(view:DisplayObject, type:Class):void {
					actual = view;
				}));
			var middle:Sprite = new Sprite();
			var middle2:Sprite = new Sprite();
			middle.addChild(middle2);
			middle2.addChild(expected);
			container.addChild(middle);
			expected.dispatchEvent(new ConfigureViewEvent(ConfigureViewEvent.CONFIGURE_VIEW));
			assertThat(actual, equalTo(expected));
		}

		[Test]
		public function view_is_not_handled_when_added_outside_container():void
		{
			const view:Sprite = new Sprite();
			var callCount:int = 0;
			registry
				.addContainer(container)
				.addHandler(new CallbackViewHandler(function(view:DisplayObject, type:Class):void {
					callCount++;
				}));
			container2.addChild(view);
			view.dispatchEvent(new ConfigureViewEvent(ConfigureViewEvent.CONFIGURE_VIEW));
			assertThat(callCount, equalTo(0));
		}

		[Test]
		public function view_is_not_handled_after_container_removal():void
		{
			const view:Sprite = new Sprite();
			var callCount:int = 0;
			registry
				.addContainer(container)
				.addHandler(new CallbackViewHandler(function(view:DisplayObject, type:Class):void {
					callCount++;
				}));
			registry.removeContainer(container);
			container.addChild(view);
			view.dispatchEvent(new ConfigureViewEvent(ConfigureViewEvent.CONFIGURE_VIEW));
			assertThat(callCount, equalTo(0));
		}

		[Test]
		public function view_is_not_handled_after_stageObserver_is_destroyed():void
		{
			const view:Sprite = new Sprite();
			var callCount:int = 0;
			registry
				.addContainer(container)
				.addHandler(new CallbackViewHandler(function(view:DisplayObject, type:Class):void {
					callCount++;
				}));
			observer.destroy();
			container.addChild(view);
			view.dispatchEvent(new ConfigureViewEvent(ConfigureViewEvent.CONFIGURE_VIEW));
			assertThat(callCount, equalTo(0));
		}
	}
}
