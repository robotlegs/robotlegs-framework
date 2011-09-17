//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.bundles.rl1
{
	import org.robotlegs.adapters.SwiftSuspendersReflector;
	import org.robotlegs.base.CommandMap;
	import org.robotlegs.base.EventMap;
	import org.robotlegs.base.MediatorMap;
	import org.robotlegs.base.ViewMap;
	import org.robotlegs.core.ICommandMap;
	import org.robotlegs.core.IEventMap;
	import org.robotlegs.core.IMediatorMap;
	import org.robotlegs.core.IReflector;
	import org.robotlegs.core.IViewMap;
	import org.robotlegs.v2.context.api.IContextBuilder;
	import org.robotlegs.v2.context.api.IContextBuilderConfig;
	import org.robotlegs.v2.processors.ParentContextFinder;

	public class RLv1Bundle implements IContextBuilderConfig
	{

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function configure(builder:IContextBuilder):void
		{
			builder
				.addProcessor(new ParentContextFinder())
				.addUtility(IReflector, SwiftSuspendersReflector)
				.addUtility(ICommandMap, CommandMap)
				.addUtility(IMediatorMap, MediatorMap)
				.addUtility(IViewMap, ViewMap)
				.addUtility(IEventMap, EventMap, false);
		}
	}
}
