//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMapA.configs
{
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.api.IContextConfig;
	import org.robotlegs.v2.extensions.mediatorMapA.api.IMediatorMap;
	import org.robotlegs.v2.extensions.mediatorMapA.utilities.triggers.DuckTypedMediatorTrigger;
	import org.robotlegs.core.IEventMap;
	import org.robotlegs.base.EventMap;
	import org.robotlegs.v2.extensions.eventMap.api.IEventMap;
	import org.robotlegs.v2.extensions.eventMap.impl.EventMap;
	import org.robotlegs.core.IEventMap;
	import org.robotlegs.base.EventMap;
	import org.robotlegs.core.IMediatorMap;
	import org.robotlegs.v2.extensions.eventMap.api.IEventMap;
	import org.robotlegs.v2.extensions.eventMap.impl.EventMap;
	import org.robotlegs.v2.extensions.mediatorMapA.impl.NullV1MediatorMap;
	
	public class DuckTypedMediatorsConfig implements IContextConfig
	{
		protected const IMediatorMapV1:Class = org.robotlegs.core.IMediatorMap;
		protected const IMediatorMapV2:Class = org.robotlegs.v2.extensions.mediatorMapA.api.IMediatorMap;
		
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

			context.injector.map(IMediatorMapV1)
							.toSingleton(NullV1MediatorMap);

			const mediatorMapA:org.robotlegs.v2.extensions.mediatorMapA.api.IMediatorMap = context.injector.getInstance(IMediatorMapV2);

			const trigger:DuckTypedMediatorTrigger = new DuckTypedMediatorTrigger(_strict);
			
			addUIComponentStrategiesIfFlex(trigger);
			
			mediatorMapA.loadTrigger(trigger);	
		}
	}
}