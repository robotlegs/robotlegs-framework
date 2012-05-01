//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{
	import org.flexunit.assertThat;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.equalTo;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IContextExtension;
	import robotlegs.bender.framework.impl.contextSupport.CallbackExtension;
	import robotlegs.bender.framework.impl.Context;

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
		public function extensions_are_installed():void
		{
			var actual:IContext;
			const extension:IContextExtension = new CallbackExtension(function(error:Object, context:IContext):void {
				actual = context;
			});
			context.extend(extension);
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
