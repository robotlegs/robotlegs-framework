//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.context.impl
{
	import org.flexunit.assertThat;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.equalTo;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.framework.configManager.support.CallbackContextConfig;
	import robotlegs.bender.framework.context.api.IContext;
	import robotlegs.bender.framework.context.api.IContextConfig;

	public class ContextTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var context:IContext;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			context = new Context();
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function can_instantiate():void
		{
			assertThat(context, isA(IContext));
		}

		[Test]
		public function configs_are_installed():void
		{
			var actual:IContext;
			const config:IContextConfig = new CallbackContextConfig(function(error:Object, context:IContext):void {
				actual = context;
			});
			context.require(config);
			assertThat(actual, equalTo(context));
		}

		[Test]
		public function constructor_configs_are_installed():void
		{
			var actual:IContext;
			const config:IContextConfig = new CallbackContextConfig(function(error:Object, context:IContext):void {
				actual = context;
			});
			context = new Context(config)
			assertThat(actual, equalTo(context));
		}

		[Test]
		public function injector_is_mapped_into_itself():void
		{
			context.injector.getInstance(SomeClass);
		}
	}
}

import org.swiftsuspenders.Injector;

class SomeClass
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject]
	public var injector:Injector;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	public function SomeClass(injector:Injector)
	{
		if (!injector)
			throw new Error("ouch");
	}
}
