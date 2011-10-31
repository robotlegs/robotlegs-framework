//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.core.impl
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import org.flexunit.asserts.assertEquals;
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.api.IContextBuilder;
	import org.swiftsuspenders.Injector;

	public class ContextBuilderTests
	{

		private var builder:IContextBuilder;

		[Before]
		public function setUp():void
		{
			builder = new ContextBuilder();
		}

		[After]
		public function tearDown():void
		{
			builder = null;
		}

		[Test(expects='Error')]
		public function build_should_throw_if_called_twice():void
		{
			builder.build();
			builder.build();
		}

		[Test]
		public function context_should_have_the_contextView_that_we_set_before_build():void
		{
			const view:DisplayObjectContainer = new Sprite();
			builder.withContextView(view);
			const context:IContext = builder.build();
			assertEquals(view, context.contextView);
		}

		[Test]
		public function context_should_have_the_dispatcher_that_we_set_before_build():void
		{
			const dispatcher:IEventDispatcher = new EventDispatcher();
			builder.withDispatcher(dispatcher);
			const context:IContext = builder.build();
			assertEquals(dispatcher, context.dispatcher);
		}

		[Test]
		public function context_should_have_the_injector_that_we_set_before_build():void
		{
			const injector:Injector = new Injector();
			builder.withInjector(injector);
			const context:IContext = builder.build();
			assertEquals(injector, context.injector);
		}

		[Test]
		public function context_should_have_the_parent_that_we_set_before_build():void
		{
			const parent:IContext = new Context();
			builder.withParent(parent);
			const context:IContext = builder.build();
			assertEquals(parent, context.parent);
		}
	}
}
