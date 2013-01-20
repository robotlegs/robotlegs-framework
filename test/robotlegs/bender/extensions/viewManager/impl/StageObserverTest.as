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
	import robotlegs.bender.extensions.viewManager.support.SupportContainer;
	import robotlegs.bender.extensions.viewManager.support.SupportView;

	public class StageObserverTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var container:UIComponent;

		private var container2:UIComponent;

		private var registry:ContainerRegistry;

		private var observer:StageObserver;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before(async, ui)]
		public function before():void
		{
			container = new UIComponent();
			container2 = new UIComponent();
			registry = new ContainerRegistry();
			observer = new StageObserver(registry);
			UIImpersonator.addChild(container);
			UIImpersonator.addChild(container2);
		}

		[After(async, ui)]
		public function after():void
		{
			UIImpersonator.removeChild(container);
			UIImpersonator.removeChild(container2);
			observer.destroy();
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function view_is_handled_when_added_to_container():void
		{
			const expected:SupportView = new SupportView();
			var actual:DisplayObject = null;
			registry
				.addContainer(container)
				.addHandler(new CallbackViewHandler(function(view:DisplayObject, type:Class):void {
					actual = view;
				}));
			container.addChild(expected);
			assertThat(actual, equalTo(expected));
		}

		[Test]
		public function view_is_handled_when_added_somewhere_inside_container():void
		{
			const expected:SupportView = new SupportView();
			var actual:DisplayObject = null;
			registry
				.addContainer(container)
				.addHandler(new CallbackViewHandler(function(view:DisplayObject, type:Class):void {
					actual = view;
				}));
			const middle:Sprite = new Sprite();
			const middle2:Sprite = new Sprite();
			middle.addChild(middle2);
			middle2.addChild(expected);
			container.addChild(middle);
			assertThat(actual, equalTo(expected));
		}

		[Test]
		public function view_is_not_handled_when_added_outside_container():void
		{
			var callCount:int = 0;
			registry
				.addContainer(container)
				.addHandler(new CallbackViewHandler(function(view:DisplayObject, type:Class):void {
					callCount++;
				}));
			container2.addChild(new SupportView());
			assertThat(callCount, equalTo(0));
		}

		[Test]
		public function view_is_not_handled_after_container_removal():void
		{
			var callCount:int = 0;
			registry
				.addContainer(container)
				.addHandler(new CallbackViewHandler(function(view:DisplayObject, type:Class):void {
					callCount++;
				}));
			registry.removeContainer(container);
			container.addChild(new SupportView());
			assertThat(callCount, equalTo(0));
		}

		[Test]
		public function view_is_not_handled_after_stageObserver_is_destroyed():void
		{
			var callCount:int = 0;
			registry
				.addContainer(container)
				.addHandler(new CallbackViewHandler(function(view:DisplayObject, type:Class):void {
					callCount++;
				}));
			observer.destroy();
			container.addChild(new SupportView());
			assertThat(callCount, equalTo(0));
		}

		[Test]
		public function flash_spark_mx_views_are_filtered_out():void
		{
			var callCount:int = 0;
			registry
				.addContainer(container)
				.addHandler(new CallbackViewHandler(function(view:DisplayObject, type:Class):void {
					callCount++;
				}));
			container.addChild(new Sprite());
			assertThat(callCount, equalTo(0));
		}

		[Test]
		public function root_container_is_handled_when_added_to_stage():void
		{
			const expected:SupportContainer = new SupportContainer();
			var actual:DisplayObject = null;
			registry
				.addContainer(expected)
				.addHandler(new CallbackViewHandler(function(view:DisplayObject, type:Class):void {
					actual = view;
				}));
			container.addChild(expected);
			assertThat(actual, equalTo(expected));
		}

	}
}
