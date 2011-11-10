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
	import org.robotlegs.v2.extensions.mediatorMapA.utilities.triggers.RL2MediatorTrigger;
	import org.robotlegs.v2.extensions.eventMap.api.IEventMap;
	import org.robotlegs.v2.extensions.eventMap.impl.EventMap;
		
	public class RL2MediatorsConfig implements IContextConfig
	{
		protected var _strict:Boolean;
		
		public function RL2MediatorsConfig(strict:Boolean = false)
		{
			_strict = strict;
		}

		public function configure(context:IContext):void
		{
			context.injector.map(IEventMap).toType(EventMap);
			
			const mediatorMapA:IMediatorMap = context.injector.getInstance(IMediatorMap);
			const trigger:RL2MediatorTrigger = new RL2MediatorTrigger(_strict);
			
			addUIComponentStrategiesIfFlex(trigger);
			
			mediatorMapA.loadTrigger(trigger);	
		}
	}
}