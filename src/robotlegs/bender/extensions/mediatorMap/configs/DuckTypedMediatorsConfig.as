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
	import robotlegs.bender.extensions.mediatorMap.utilities.triggers.DuckTypedMediatorTrigger;
	import org.robotlegs.core.IEventMap;
	import org.robotlegs.base.EventMap;
	import robotlegs.bender.extensions.eventMap.api.IEventMap;
	import robotlegs.bender.extensions.eventMap.impl.EventMap;
	import org.robotlegs.core.IEventMap;
	import org.robotlegs.base.EventMap;
	import org.robotlegs.core.IMediatorMap;
	import robotlegs.bender.extensions.eventMap.api.IEventMap;
	import robotlegs.bender.extensions.eventMap.impl.EventMap;
	import robotlegs.bender.extensions.mediatorMap.impl.RL1MediatorMapAdapter;

	public class DuckTypedMediatorsConfig implements IContextConfig
	{
		protected const IMediatorMapV1:Class = org.robotlegs.core.IMediatorMap;
		protected const IMediatorMapV2:Class = robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
		protected const MediatorMapV2:Class = robotlegs.bender.extensions.mediatorMap.impl.MediatorMap;

		protected var _strict:Boolean;

		public function DuckTypedMediatorsConfig(strict:Boolean = false)
		{
			_strict = strict;
		}

		public function configure(context:IContext):void
		{
			context.injector.map(org.robotlegs.core.IEventMap)
							.toType(org.robotlegs.base.EventMap);

			context.injector.map(robotlegs.bender.extensions.eventMap.api.IEventMap)
							.toType(robotlegs.bender.extensions.eventMap.impl.EventMap);

			const mediatorMap:robotlegs.bender.extensions.mediatorMap.api.IMediatorMap = context.injector.getInstance(IMediatorMapV2);

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