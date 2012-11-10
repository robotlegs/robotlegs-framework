//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{
	import org.flexunit.assertThat;
	import org.hamcrest.core.isA;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.strictlyEqualTo;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;
	import robotlegs.bender.framework.impl.contextSupport.CallbackExtension;

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
			var actual:IContext = null;
			const extension:IExtension = new CallbackExtension(
				function(error:Object, context:IContext):void {
					actual = context;
				});
			context.install(extension);
			assertThat(actual, equalTo(context));
		}

		[Test]
		public function injector_is_mapped_into_itself():void
		{
			const injector:Injector = context.injector.getInstance(Injector);
			assertThat(injector, strictlyEqualTo(context.injector));
		}

		[Test]
		public function detain_is_pretty_much_untestable():void
		{
			context.detain({}, {});
		}

		[Test]
		public function release_is_pretty_much_untestable():void
		{
			context.release({}, {});
		}
	}
}
