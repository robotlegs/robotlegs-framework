//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2old.bundles.rl1
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
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.api.IContextExtension;

	public class RLv1Extension implements IContextExtension
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var context:IContext;

		private var injector:IInjector;


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function initialize(context:IContext):void
		{
		}

		public function install(context:IContext):void
		{
			this.context = context;
			injector = context.injector;
			injector.mapSingletonOf(IReflector, SwiftSuspendersReflector);
			injector.mapSingletonOf(ICommandMap, CommandMap);
			injector.mapSingletonOf(IMediatorMap, MediatorMap);
			injector.mapSingletonOf(IViewMap, ViewMap);
			injector.mapClass(IEventMap, EventMap);

		}

		public function uninstall(context:IContext):void
		{
		}
	}
}
