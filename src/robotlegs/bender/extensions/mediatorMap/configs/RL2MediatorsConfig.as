//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.configs
{
	import robotlegs.bender.core.api.IContext;
	import robotlegs.bender.core.api.IContextConfig;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.extensions.mediatorMap.utilities.triggers.RL2MediatorTrigger;
	import robotlegs.bender.extensions.eventMap.api.IEventMap;
	import robotlegs.bender.extensions.eventMap.impl.EventMap;

	public class RL2MediatorsConfig implements IContextConfig
	{
		protected var _strict:Boolean;

		public function RL2MediatorsConfig(strict:Boolean = false)
		{
			_strict = strict;
		}

		public function configure(context:IContext):void
		{
			// TODO: remove this. The EventMap is an optional extension (even if required by MediatorMap)
			context.injector.map(IEventMap).toType(EventMap);

			const mediatorMap:IMediatorMap = context.injector.getInstance(IMediatorMap);
			const trigger:RL2MediatorTrigger = new RL2MediatorTrigger(_strict);

			addUIComponentStrategiesIfFlex(trigger);

			mediatorMap.loadTrigger(trigger);
		}
	}
}