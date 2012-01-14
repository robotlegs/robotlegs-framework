//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventCommandMap
{
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.extensions.eventCommandMap.impl.EventCommandMap;
	import robotlegs.bender.framework.context.api.IContext;
	import robotlegs.bender.framework.context.api.IContextConfig;

	public class EventCommandMapExtension implements IContextConfig
	{

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function configureContext(context:IContext):void
		{
			context.injector.map(IEventCommandMap).toSingleton(EventCommandMap);
		}
	}
}
