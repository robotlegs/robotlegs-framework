//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.logging
{
	import org.flexunit.assertThat;
	import org.hamcrest.object.instanceOf;
	import robotlegs.bender.framework.context.impl.Context;
	import robotlegs.bender.framework.logging.api.ILogger;
	import robotlegs.bender.framework.object.managed.impl.ManagedObject;

	public class LoggingExtensionTest
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
			context.extend(LoggingExtension);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function logger_is_mapped_into_injector():void
		{
			var actual:Object;
			context.addStateHandler(ManagedObject.SELF_INITIALIZE, function():void {
				actual = context.injector.getInstance(ILogger);
			});
			context.initialize();
			assertThat(actual, instanceOf(ILogger));
		}
	}
}
