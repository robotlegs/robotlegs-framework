//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventCommandMap
{
	import robotlegs.bender.core.api.IContext;
	import robotlegs.bender.core.api.IContextExtension;
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.extensions.eventCommandMap.impl.EventCommandMap;

	public class EventCommandMapExtension implements IContextExtension
	{
		private var context:IContext;

		public function install(context:IContext):void
		{
			this.context = context;
			context.injector.map(IEventCommandMap).toSingleton(EventCommandMap);
		}

		public function initialize():void
		{
			context.injector.getInstance(IEventCommandMap);
		}

		public function uninstall():void
		{
			context.injector.unmap(IEventCommandMap);
		}
	}
}
