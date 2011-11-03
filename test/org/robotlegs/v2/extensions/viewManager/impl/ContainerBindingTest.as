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
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;
	import org.robotlegs.v2.extensions.viewManager.api.IViewHandler;
	import org.robotlegs.v2.extensions.viewManager.impl.support.ViewHandlerSupport;
	import org.flexunit.asserts.assertEqualsVectorsIgnoringOrder;
	import ArgumentError;

	public class ContainerBindingTest
	{

		protected var instance:ContainerBinding;
		protected const CONTAINER:DisplayObjectContainer = new Sprite();
		protected const HANDLER_1:IViewHandler = new ViewHandlerSupport();
		protected const HANDLER_2:IViewHandler = new ViewHandlerSupport();
		protected const HANDLER_3:IViewHandler = new ViewHandlerSupport();
		protected const ZERO_HANDLER:IViewHandler = new ViewHandlerSupport(0);

		[Before]
		public function setUp():void
		{
			instance = new ContainerBinding(CONTAINER);
		}

		[After]
		public function tearDown():void
		{
			instance = null;
		}

		[Test]
		public function get_container_returns_given_container():void
		{
			assertThat(instance.container, equalTo(CONTAINER));
		}
		
		[Test]
		public function set_and_get_parent_returns_given_value():void 
		{
			const test_parent:ContainerBinding = new ContainerBinding(new Sprite());
			instance.parent =  test_parent;
			assertThat(instance.parent, equalTo(test_parent));
		}
		
		[Test]
		public function handlers_is_initially_empty():void
		{
			assertThat(instance.handlers.length, equalTo(0));
		}
		
		[Test]
		public function adding_a_handler_puts_it_in_the_handlers_list():void
		{
			instance.addHandler(HANDLER_1);
			instance.addHandler(HANDLER_2);
			
			const expectedHandlers:Vector.<IViewHandler> = new <IViewHandler>[HANDLER_1, HANDLER_2];
			assertEqualsVectorsIgnoringOrder(expectedHandlers, instance.handlers);
		}
		
		[Test]
		public function removing_a_handler_takes_it_out_of_the_list():void
		{
			instance.addHandler(HANDLER_1);
			instance.addHandler(HANDLER_2);
			instance.addHandler(HANDLER_3);

			instance.removeHandler(HANDLER_2);
			
			const expectedHandlers:Vector.<IViewHandler> = new <IViewHandler>[HANDLER_1, HANDLER_3];
			assertEqualsVectorsIgnoringOrder(expectedHandlers, instance.handlers);
		}
		
		[Test]
		public function adding_the_same_handler_repeatedly_doesnt_duplicate_it_in_the_list():void
		{
			instance.addHandler(HANDLER_1);
			instance.addHandler(HANDLER_2);
			instance.addHandler(HANDLER_3);
			instance.addHandler(HANDLER_1);
			instance.addHandler(HANDLER_2);
			instance.addHandler(HANDLER_3);

			const expectedHandlers:Vector.<IViewHandler> = new <IViewHandler>[HANDLER_1, HANDLER_2, HANDLER_3];
			assertEqualsVectorsIgnoringOrder(expectedHandlers, instance.handlers);
		}
		
		[Test(expects="ArgumentError")]
		public function adding_a_handler_with_zero_interest_throws_error():void
		{
			instance.addHandler(ZERO_HANDLER);
		}
	}
}