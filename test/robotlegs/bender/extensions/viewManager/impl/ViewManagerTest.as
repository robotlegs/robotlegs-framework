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
	import org.hamcrest.collection.array;
	import org.hamcrest.object.equalTo;
	import robotlegs.bender.extensions.viewManager.support.CallbackViewHandler;
	import robotlegs.bender.extensions.viewManager.support.SupportView;

	public class ViewManagerTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var container:UIComponent;

		private var viewManager:ViewManager;

		private var stageObserver:StageObserver;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before(async, ui)]
		public function before():void
		{
			container = new UIComponent();
			const registry:ContainerRegistry = new ContainerRegistry();
			viewManager = new ViewManager(registry);
			stageObserver = new StageObserver(registry);
			UIImpersonator.addChild(container);
		}

		[After(async, ui)]
		public function after():void
		{
			UIImpersonator.removeChild(container);
			stageObserver.destroy();
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function addContainer():void
		{
			viewManager.addContainer(new SupportView());
		}

		[Test(expects="Error")]
		public function addContainer_throws_if_containers_are_nested():void
		{
			const container1:Sprite = new Sprite();
			const container2:Sprite = new Sprite();
			container1.addChild(container2);
			viewManager.addContainer(container1);
			viewManager.addContainer(container2);
		}

		[Test]
		public function handler_is_called():void
		{
			const expected:SupportView = new SupportView();
			var actual:DisplayObject = null;
			viewManager.addContainer(container);
			viewManager.addViewHandler(new CallbackViewHandler(function(view:DisplayObject, type:Class):void {
				actual = view;
			}));
			container.addChild(expected);
			assertThat(actual, equalTo(expected));
		}

		[Test]
		public function handlers_are_called():void
		{
			const expected:Array = ['handler1', 'handler2', 'handler3'];
			var actual:Array = [];
			viewManager.addContainer(container);
			viewManager.addViewHandler(new CallbackViewHandler(function(view:DisplayObject, type:Class):void {
				actual.push('handler1');
			}));
			viewManager.addViewHandler(new CallbackViewHandler(function(view:DisplayObject, type:Class):void {
				actual.push('handler2');
			}));
			viewManager.addViewHandler(new CallbackViewHandler(function(view:DisplayObject, type:Class):void {
				actual.push('handler3');
			}));
			container.addChild(new SupportView());
			assertThat(actual, array(expected));
		}

		[Test]
		public function handler_is_not_called_after_container_removal():void
		{
			var callCount:int = 0;
			viewManager.addContainer(container);
			viewManager.addViewHandler(new CallbackViewHandler(function(view:DisplayObject, type:Class):void {
				callCount++;
			}));
			viewManager.removeContainer(container);
			container.addChild(new SupportView());
			assertThat(callCount, equalTo(0));
		}

		[Test]
		public function handler_is_not_called_after_removeAll():void
		{
			var callCount:int = 0;
			viewManager.addContainer(container);
			viewManager.addViewHandler(new CallbackViewHandler(function(view:DisplayObject, type:Class):void {
				callCount++;
			}));
			viewManager.removeAllHandlers();
			container.addChild(new SupportView());
			assertThat(callCount, equalTo(0));
		}
	}
}
