//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap.configs
{
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.api.IContextConfig;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediatorMap;
	import org.robotlegs.v2.extensions.mediatorMap.utilities.triggers.RL1AndRL2MediatorTrigger;
	import org.robotlegs.v2.extensions.mediatorMap.configs.addUIComponentStrategiesIfFlex;
	import org.robotlegs.core.IEventMap;
	import org.robotlegs.base.EventMap;
	import org.robotlegs.core.IMediatorMap;
	import org.robotlegs.base.MediatorMap;
	import org.robotlegs.v2.extensions.eventMap.api.IEventMap;
	import org.robotlegs.v2.extensions.eventMap.impl.EventMap;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.adapters.SwiftSuspendersInjector;
	import org.robotlegs.v2.extensions.mediatorMap.impl.NullV1MediatorMap;
	
	public class RL1AndRL2MediatorsConfig implements IContextConfig
	{
		protected var _strict:Boolean;
		
		protected const IMediatorMapV1:Class = org.robotlegs.core.IMediatorMap;
		protected const IMediatorMapV2:Class = org.robotlegs.v2.extensions.mediatorMap.api.IMediatorMap;
		
		public function RL1AndRL2MediatorsConfig(strict:Boolean = false)
		{
			_strict = strict;
		}

		public function configure(context:IContext):void
		{
			context.injector.map(org.robotlegs.core.IEventMap)
							.toType(org.robotlegs.base.EventMap);
							
			context.injector.map(org.robotlegs.v2.extensions.eventMap.api.IEventMap)
							.toType(org.robotlegs.v2.extensions.eventMap.impl.EventMap);
							
			context.injector.map(IMediatorMapV1)
							.toSingleton(NullV1MediatorMap);
						
			const mediatorMap:org.robotlegs.v2.extensions.mediatorMap.api.IMediatorMap = context.injector.getInstance(IMediatorMapV2);

			const trigger:RL1AndRL2MediatorTrigger = new RL1AndRL2MediatorTrigger(_strict);
			
			addUIComponentStrategiesIfFlex(trigger);
			
			mediatorMap.loadTrigger(trigger);	
		}
	}
}