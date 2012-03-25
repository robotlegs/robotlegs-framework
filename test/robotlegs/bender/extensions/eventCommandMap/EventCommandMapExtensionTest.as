//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventCommandMap
{
	import org.flexunit.assertThat;
	import org.hamcrest.object.instanceOf;
	import robotlegs.bender.extensions.commandMap.CommandMapExtension;
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.extensions.eventDispatcher.EventDispatcherExtension;
	import robotlegs.bender.framework.context.impl.Context;
	import robotlegs.bender.framework.object.managed.impl.ManagedObject;

	public class EventCommandMapExtensionTest
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
			context.extend(EventDispatcherExtension, CommandMapExtension);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function eventCommandMap_is_mapped_into_injector():void
		{
			var actual:Object;
			context.extend(EventCommandMapExtension);
			context.addStateHandler(ManagedObject.SELF_INITIALIZE, function():void {
				actual = context.injector.getInstance(IEventCommandMap);
			});
			context.initialize();
			assertThat(actual, instanceOf(IEventCommandMap));
		}
	}
}
