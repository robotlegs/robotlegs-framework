//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap.configs
{
	import flash.display.DisplayObject;
	import flash.utils.getDefinitionByName;
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.api.IContextConfig;
	import org.robotlegs.v2.core.impl.TypeMatcher;
	import org.robotlegs.v2.core.utilities.checkUIComponentAvailable;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediatorMap;
	import org.robotlegs.v2.extensions.mediatorMap.utilities.strategies.NoWaitStrategy;
	import org.robotlegs.v2.extensions.mediatorMap.utilities.strategies.WaitForCreationCompleteStrategy;
	import org.robotlegs.v2.extensions.mediatorMap.utilities.triggers.RL1MediatorTrigger;
	import org.robotlegs.core.IEventMap;
	import org.robotlegs.base.EventMap;
	import org.robotlegs.core.IMediatorMap;
	import org.robotlegs.v2.extensions.mediatorMap.impl.NullV1MediatorMap;
		
	public class RL1MediatorsConfig implements IContextConfig
	{
		protected const IMediatorMapV1:Class = org.robotlegs.core.IMediatorMap;
		protected const IMediatorMapV2:Class = org.robotlegs.v2.extensions.mediatorMap.api.IMediatorMap;

		protected var _strict:Boolean;

		public function RL1MediatorsConfig(strict:Boolean = false)
		{
			_strict = strict;
		}

		public function configure(context:IContext):void
		{
			context.injector.map(IEventMap).toType(EventMap);
			const mediatorMap:org.robotlegs.v2.extensions.mediatorMap.api.IMediatorMap = context.injector.getInstance(IMediatorMapV2);
			
			const trigger:RL1MediatorTrigger = new RL1MediatorTrigger(_strict);

			context.injector.map(IMediatorMapV1)
							.toSingleton(NullV1MediatorMap);
			
			mediatorMap.loadTrigger(trigger);	
		}
	}
}