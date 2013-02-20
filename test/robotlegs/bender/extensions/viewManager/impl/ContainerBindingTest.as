//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager.impl
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import org.flexunit.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.object.equalTo;
	import robotlegs.bender.extensions.viewManager.api.IViewHandler;
	import robotlegs.bender.extensions.viewManager.support.CallbackViewHandler;

	public class ContainerBindingTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var binding:ContainerBinding;

		private var container:DisplayObjectContainer;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			binding = new ContainerBinding(container);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function container_is_stored():void
		{
			assertThat(binding.container, equalTo(container));
		}

		[Test]
		public function handler_is_invoked():void
		{
			var callCount:int = 0;
			binding.addHandler(new CallbackViewHandler(function(view:DisplayObject, type:Class):void {
				callCount++;
			}));
			binding.handleView(new Sprite(), Sprite);
			assertThat(callCount, equalTo(1));
		}

		[Test]
		public function handler_is_passed_correct_details():void
		{
			const expectedView:Sprite = new Sprite();
			const expectedType:Class = Sprite;
			var actualView:DisplayObject = null;
			var actualType:Class = null;
			binding.addHandler(new CallbackViewHandler(function(view:DisplayObject, type:Class):void {
				actualView = view;
				actualType = type;
			}));
			binding.handleView(expectedView, expectedType);
			assertThat(actualView, equalTo(expectedView));
			assertThat(actualType, equalTo(expectedType));
		}

		[Test]
		public function handler_is_not_invoked_after_removal():void
		{
			var callCount:int = 0;
			const handler:IViewHandler = new CallbackViewHandler(function(view:DisplayObject, type:Class):void {
				callCount++;
			});
			binding.addHandler(handler);
			binding.removeHandler(handler);
			binding.handleView(new Sprite(), Sprite);
			assertThat(callCount, equalTo(0));
		}

		[Test]
		public function handler_is_not_invoked_multiple_times_when_added_multiple_times():void
		{
			var callCount:int = 0;
			const handler:IViewHandler = new CallbackViewHandler(function(view:DisplayObject, type:Class):void {
				callCount++;
			});
			binding.addHandler(handler);
			binding.addHandler(handler);
			binding.addHandler(handler);
			binding.handleView(new Sprite(), Sprite);
			assertThat(callCount, equalTo(1));
		}

		[Test]
		public function handlers_are_invoked_in_order():void
		{
			const expected:Array = ['handler1', 'handler2', 'handler3'];
			var actual:Array = [];
			binding.addHandler(new CallbackViewHandler(function(view:DisplayObject, type:Class):void {
				actual.push('handler1');
			}));
			binding.addHandler(new CallbackViewHandler(function(view:DisplayObject, type:Class):void {
				actual.push('handler2');
			}));
			binding.addHandler(new CallbackViewHandler(function(view:DisplayObject, type:Class):void {
				actual.push('handler3');
			}));
			binding.handleView(new Sprite(), Sprite);
			assertThat(actual, array(expected));
		}

		[Test]
		public function binding_fires_event_on_empty():void
		{
			const handler:IViewHandler = new CallbackViewHandler();
			var callCount:int = 0;
			binding.addEventListener(ContainerBindingEvent.BINDING_EMPTY, function(event:ContainerBindingEvent):void {
				callCount++;
			});
			binding.addHandler(handler);
			binding.removeHandler(handler);
			assertThat(callCount, equalTo(1));
		}
	}
}

