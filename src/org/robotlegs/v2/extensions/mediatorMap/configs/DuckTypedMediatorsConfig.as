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
	import org.robotlegs.v2.extensions.mediatorMap.utilities.triggers.DuckTypedMediatorTrigger;
	import org.robotlegs.core.IEventMap;
	import org.robotlegs.base.EventMap;
	import org.robotlegs.v2.extensions.eventMap.api.IEventMap;
	import org.robotlegs.v2.extensions.eventMap.impl.EventMap;
	import org.robotlegs.core.IEventMap;
	import org.robotlegs.base.EventMap;
	import org.robotlegs.core.IMediatorMap;
	import org.robotlegs.v2.extensions.eventMap.api.IEventMap;
	import org.robotlegs.v2.extensions.eventMap.impl.EventMap;
	import org.robotlegs.v2.extensions.mediatorMap.impl.RL1MediatorMapAdapter;
	
	public class DuckTypedMediatorsConfig implements IContextConfig
	{
		protected const IMediatorMapV1:Class = org.robotlegs.core.IMediatorMap;
		protected const IMediatorMapV2:Class = org.robotlegs.v2.extensions.mediatorMap.api.IMediatorMap;
		protected const MediatorMapV2:Class = org.robotlegs.v2.extensions.mediatorMap.impl.MediatorMap;
		
		protected var _strict:Boolean;

		public function DuckTypedMediatorsConfig(strict:Boolean = false)
		{
			_strict = strict;
		}

		public function configure(context:IContext):void
		{
			context.injector.map(org.robotlegs.core.IEventMap)
							.toType(org.robotlegs.base.EventMap);
							
			context.injector.map(org.robotlegs.v2.extensions.eventMap.api.IEventMap)
							.toType(org.robotlegs.v2.extensions.eventMap.impl.EventMap);

			const mediatorMap:org.robotlegs.v2.extensions.mediatorMap.api.IMediatorMap = context.injector.getInstance(IMediatorMapV2);

			context.injector.map(MediatorMapV2)
							.toValue(mediatorMap);

			context.injector.map(IMediatorMapV1)
							.toSingleton(RL1MediatorMapAdapter);

			const trigger:DuckTypedMediatorTrigger = new DuckTypedMediatorTrigger(_strict);
			
			addUIComponentStrategiesIfFlex(trigger);
			
			mediatorMap.loadTrigger(trigger);	
		}
	}
}