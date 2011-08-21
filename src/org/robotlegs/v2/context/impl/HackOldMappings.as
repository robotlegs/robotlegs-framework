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
	import org.swiftsuspenders.v2.dsl.IInjector;

	public class HackOldMappings
	{

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function HackOldMappings(inj:org.swiftsuspenders.v2.dsl.IInjector)
		{
			var injector:org.robotlegs.core.IInjector = inj['hack_inj'];

			injector.mapValue(IReflector, new SwiftSuspendersReflector());
			injector.mapValue(org.robotlegs.core.IInjector, injector);

			injector.mapSingletonOf(ICommandMap, CommandMap);
			injector.mapSingletonOf(IMediatorMap, MediatorMap);
			injector.mapSingletonOf(IViewMap, ViewMap);

			injector.mapClass(IEventMap, EventMap);

		}
	}
}
