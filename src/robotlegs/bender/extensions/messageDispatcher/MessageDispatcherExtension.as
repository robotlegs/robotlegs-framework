//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.messageDispatcher
{
	import robotlegs.bender.core.message.dispatcher.api.IMessageDispatcher;
	import robotlegs.bender.core.message.dispatcher.impl.MessageDispatcher;
	import robotlegs.bender.framework.context.api.IContext;
	import robotlegs.bender.framework.context.api.IContextConfig;

	public class MessageDispatcherExtension implements IContextConfig
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _messageDispatcher:IMessageDispatcher;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function MessageDispatcherExtension(messageDispatcher:IMessageDispatcher = null)
		{
			_messageDispatcher = messageDispatcher || new MessageDispatcher();
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function configureContext(context:IContext):void
		{
			context.injector.map(IMessageDispatcher).toValue(_messageDispatcher);
		}
	}
}
