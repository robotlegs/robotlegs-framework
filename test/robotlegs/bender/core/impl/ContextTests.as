//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.core.impl
{
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	import mx.core.UIComponent;
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.fluint.uiImpersonation.UIImpersonator;
	import org.hamcrest.object.notNullValue;
	import org.hamcrest.object.strictlyEqualTo;
	import robotlegs.bender.core.api.IContext;
	import org.swiftsuspenders.Injector;

	public class ContextTests
	{

		private var context:IContext;

		private var contextView:DisplayObjectContainer;

		[Before(ui)]
		public function setUp():void
		{
			context = new Context();
			contextView = new UIComponent();
			UIImpersonator.addChild(contextView);
		}

		[After]
		public function tearDown():void
		{
			context = null;
			UIImpersonator.removeAllChildren();
		}

		[Test]
		public function a_default_dispatcher_should_be_used_if_none_provided():void
		{
			context.initialize(nullCallback);
			assertThat(context.dispatcher, notNullValue());
		}

		[Test]
		public function a_default_injector_should_be_used_if_none_provided():void
		{
			context.initialize(nullCallback);
			assertThat(context.injector, notNullValue());
		}

		[Test]
		public function applicationDomain_that_is_not_explicitly_set_is_determined_by_contextView_if_provided():void
		{
			context.contextView = contextView;
			context.initialize(nullCallback);
			assertEquals(contextView.loaderInfo.applicationDomain, context.applicationDomain);
		}

		[Test(expects='Error')]
		public function destroy_should_throw_if_called_twice():void
		{
			context.destroy();
			context.destroy();
		}

		[Test(expects='Error')]
		public function initialize_should_throw_if_called_twice():void
		{
			context.initialize(nullCallback);
			context.initialize(nullCallback);
		}

		[Test]
		public function injector_should_be_childInjector_if_parent_provided_and_no_injector_given():void
		{
			const parent:IContext = new Context();
			parent.initialize(nullCallback);
			context.parent = parent;
			context.initialize(nullCallback);
			assertThat(context.injector.parentInjector, strictlyEqualTo(parent.injector));
		}

		[Test]
		public function provided_dispatcher_should_be_used():void
		{
			const providedDispatcher:EventDispatcher = new EventDispatcher();
			context.dispatcher = providedDispatcher;
			context.initialize(nullCallback);
			assertThat(context.dispatcher, strictlyEqualTo(providedDispatcher));
		}

		[Test]
		public function provided_injector_should_be_used():void
		{
			const providedInjector:Injector = new Injector();
			context.injector = providedInjector;
			context.initialize(nullCallback);
			assertThat(context.injector, strictlyEqualTo(providedInjector));
		}

		[Test(expects='Error')]
		public function setting_contextView_should_throw_if_context_already_initialized():void
		{
			context.initialize(nullCallback);
			context.contextView = contextView;
		}

		[Test(expects='Error')]
		public function setting_dispatcher_should_throw_if_context_already_initialized():void
		{
			context.initialize(nullCallback);
			context.dispatcher = new EventDispatcher();
		}

		[Test(expects='Error')]
		public function setting_injector_should_throw_if_context_already_initialized():void
		{
			context.initialize(nullCallback);
			context.injector = new Injector();
		}

		[Test(expects='Error')]
		public function setting_parent_should_throw_if_context_already_initialized():void
		{
			context.initialize(nullCallback);
			context.parent = new Context();
		}

		private function nullCallback():void
		{
		}
	}
}
