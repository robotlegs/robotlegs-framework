//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.bundles.rl1
{
	import org.as3commons.logging.api.LOGGER_FACTORY;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.setup.target.TraceTarget;
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
	import org.robotlegs.v2.context.api.IContextBuilderBundle;
	import org.robotlegs.v2.processors.ParentContextFinder;

	public class RLv1Bundle implements IContextBuilderBundle
	{

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function install(builder:IContextBuilder):void
		{
			LOGGER_FACTORY.setup = new SimpleTargetSetup(new TraceTarget());
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
