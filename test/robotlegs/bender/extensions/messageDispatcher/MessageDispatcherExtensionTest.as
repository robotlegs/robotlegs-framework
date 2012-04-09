//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.messageDispatcher
{
	import org.flexunit.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import robotlegs.bender.core.messaging.IMessageDispatcher;
	import robotlegs.bender.core.messaging.MessageDispatcher;
	import robotlegs.bender.framework.context.api.IContext;
	import robotlegs.bender.framework.context.impl.Context;
	import robotlegs.bender.framework.object.managed.impl.ManagedObject;

	public class MessageDispatcherExtensionTest
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
		public function a_MessageDispatcher_is_mapped_into_injector():void
		{
			var actual:Object;
			context.extend(MessageDispatcherExtension);
			context.addStateHandler(ManagedObject.SELF_INITIALIZE, function():void {
				actual = context.injector.getInstance(IMessageDispatcher);
			});
			context.initialize();
			assertThat(actual, instanceOf(IMessageDispatcher));
		}

		[Test]
		public function provided_MessageDispatcher_is_mapped_into_injector():void
		{
			const expected:IMessageDispatcher = new MessageDispatcher();
			var actual:Object;
			context.extend(new MessageDispatcherExtension(expected));
			context.addStateHandler(ManagedObject.SELF_INITIALIZE, function():void {
				actual = context.injector.getInstance(IMessageDispatcher);
			});
			context.initialize();
			assertThat(actual, equalTo(expected));
		}
	}
}
