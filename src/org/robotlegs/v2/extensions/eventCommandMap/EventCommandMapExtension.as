//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.eventCommandMap
{
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.api.IContextExtension;
	import org.robotlegs.v2.extensions.eventCommandMap.api.IEventCommandMap;
	import org.robotlegs.v2.extensions.eventCommandMap.impl.EventCommandMap;

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
