//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventMap
{
	import robotlegs.bender.extensions.eventMap.api.IEventMap;
	import robotlegs.bender.extensions.eventMap.impl.EventMap;
	import robotlegs.bender.framework.context.api.IContext;
	import robotlegs.bender.framework.context.api.IContextConfig;

	// TODO: consider calling this LocalEventMap
	public class EventMapExtension implements IContextConfig
	{

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function configureContext(context:IContext):void
		{
			context.injector.map(IEventMap).toType(EventMap);
		}
	}
}
