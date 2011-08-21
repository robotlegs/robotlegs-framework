//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.context.impl
{
	import org.robotlegs.adapters.SwiftSuspendersReflector;
	import org.robotlegs.base.CommandMap;
	import org.robotlegs.base.EventMap;
	import org.robotlegs.base.MediatorMap;
	import org.robotlegs.base.ViewMap;
	import org.robotlegs.core.ICommandMap;
	import org.robotlegs.core.IEventMap;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IMediatorMap;
	import org.robotlegs.core.IReflector;
	import org.robotlegs.core.IViewMap;

	public class HackOldMappings
	{

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function HackOldMappings(injector:IInjector)
		{
			injector.mapValue(IReflector, new SwiftSuspendersReflector());

			injector.mapSingletonOf(ICommandMap, CommandMap);
			injector.mapSingletonOf(IMediatorMap, MediatorMap);
			injector.mapSingletonOf(IViewMap, ViewMap);

			injector.mapClass(IEventMap, EventMap);
		}
	}
}
