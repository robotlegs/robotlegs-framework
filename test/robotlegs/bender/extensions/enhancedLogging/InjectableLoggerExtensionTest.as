//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.enhancedLogging
{
	import org.flexunit.assertThat;
	import org.hamcrest.object.instanceOf;
	import robotlegs.bender.framework.impl.Context;
	import robotlegs.bender.framework.api.ILogger;

	public class InjectableLoggerExtensionTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var context:Context;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			context = new Context();
			context.install(InjectableLoggerExtension);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function logger_is_mapped_into_injector():void
		{
			var actual:Object = null;
			context.whenInitializing( function():void {
				actual = context.injector.getInstance(ILogger);
			});
			context.initialize();
			assertThat(actual, instanceOf(ILogger));
		}
	}
}
