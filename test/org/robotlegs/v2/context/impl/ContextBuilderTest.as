//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.context.impl
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import org.flexunit.asserts.assertEquals;
	import org.robotlegs.adapters.SwiftSuspendersInjector;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.impl.Context;
	import org.robotlegs.v2.core.impl.ContextBuilder;

	public class ContextBuilderTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var builder:ContextBuilder;


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

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
			const injector:IInjector = new SwiftSuspendersInjector();
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
	}
}
