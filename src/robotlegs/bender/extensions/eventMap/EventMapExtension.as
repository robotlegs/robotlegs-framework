//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventMap
{
	import robotlegs.bender.core.api.IContext;
	import robotlegs.bender.core.api.IContextExtension;
	import robotlegs.bender.extensions.eventMap.api.IEventMap;
	import robotlegs.bender.extensions.eventMap.impl.EventMap;

	// TODO: consider calling this LocalEventMap
	public class EventMapExtension implements IContextExtension
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var context:IContext;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function install(context:IContext):void
		{
			this.context = context;
			context.injector.map(IEventMap).toType(EventMap);
		}

		public function initialize():void
		{
		}

		public function uninstall():void
		{
			context.injector.unmap(IEventMap);
		}
	}
}
