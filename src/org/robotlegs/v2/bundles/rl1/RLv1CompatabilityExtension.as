//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.bundles.rl1
{
	import org.robotlegs.adapters.SwiftSuspendersInjector;
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
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.api.IContextExtension;
	import org.swiftsuspenders.Injector;

	public class RLv1CompatabilityExtension implements IContextExtension
	{

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function initialize(context:IContext):void
		{
		}

		public function install(context:IContext):void
		{
			const injector:Injector = context.injector;
			const iinjector:IInjector = new SwiftSuspendersInjector(injector);

			injector.map(IInjector).toValue(iinjector);
			injector.map(IReflector).toSingleton(SwiftSuspendersReflector);
			injector.map(ICommandMap).toSingleton(CommandMap);
			injector.map(IMediatorMap).toSingleton(MediatorMap);
			injector.map(IViewMap).toSingleton(ViewMap);
			injector.map(IEventMap).toType(EventMap);
		}

		public function uninstall(context:IContext):void
		{
		}
	}
}
