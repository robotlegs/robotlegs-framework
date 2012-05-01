//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.messageCommandMap
{
	import org.flexunit.assertThat;
	import org.hamcrest.object.instanceOf;
	import robotlegs.bender.extensions.commandMap.CommandMapExtension;
	import robotlegs.bender.extensions.messageCommandMap.api.IMessageCommandMap;
	import robotlegs.bender.extensions.messageDispatcher.MessageDispatcherExtension;
	import robotlegs.bender.framework.impl.Context;

	public class MessageCommandMapExtensionTest
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
			context.extend(MessageDispatcherExtension, CommandMapExtension);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function messageCommandMap_is_mapped_into_injector():void
		{
			var actual:Object = null;
			context.extend(MessageCommandMapExtension);
			context.lifecycle.whenInitializing(function():void {
				actual = context.injector.getInstance(IMessageCommandMap);
			});
			context.initialize();
			assertThat(actual, instanceOf(IMessageCommandMap));
		}
	}
}
