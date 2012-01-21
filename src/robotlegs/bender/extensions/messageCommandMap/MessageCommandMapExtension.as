//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.messageCommandMap
{
	import robotlegs.bender.extensions.messageCommandMap.api.IMessageCommandMap;
	import robotlegs.bender.extensions.messageCommandMap.impl.MessageCommandMap;
	import robotlegs.bender.framework.context.api.IContext;
	import robotlegs.bender.framework.context.api.IContextConfig;

	public class MessageCommandMapExtension implements IContextConfig
	{

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function configureContext(context:IContext):void
		{
			context.injector.map(IMessageCommandMap).toSingleton(MessageCommandMap);
		}
	}
}
