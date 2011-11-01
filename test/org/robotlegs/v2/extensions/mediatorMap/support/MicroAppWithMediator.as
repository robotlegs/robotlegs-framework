//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap.support
{
	import org.robotlegs.v2.core.impl.ContextBuilder;
	import flash.display.Sprite;
	import org.swiftsuspenders.Injector;
	import org.robotlegs.v2.extensions.mediatorMap.MediatorMapExtension;
	import org.robotlegs.v2.extensions.viewManager.ViewManagerExtension;
	import org.robotlegs.v2.bundles.shared.configs.ContextViewListenerConfig;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediatorMap;
	import flash.display.MovieClip;
	import org.robotlegs.v2.extensions.mediatorMap.support.TracingMediator;
	import org.robotlegs.v2.core.api.ContextBuilderEvent;
	import org.robotlegs.v2.extensions.viewManager.AutoStageListenerExtension;
	import org.robotlegs.v2.extensions.mediatorMap.impl.support.MediatorWatcher;
	import org.robotlegs.v2.extensions.mediatorMap.configs.RL2MediatorsStrictConfig;

	public class MicroAppWithMediator extends Sprite
	{
	
		protected var _mediatorWatcher:MediatorWatcher;
	
		public function MicroAppWithMediator()
		{
		}
	
		public function buildContext(completeHandler:Function, mediatorWatcher:MediatorWatcher):void
		{
			_mediatorWatcher = mediatorWatcher;
			
			const contextBuilder:ContextBuilder = new ContextBuilder();

			contextBuilder.addEventListener(ContextBuilderEvent.CONTEXT_BUILD_COMPLETE, addMappings);
			contextBuilder.addEventListener(ContextBuilderEvent.CONTEXT_BUILD_COMPLETE, completeHandler);
			
			// eventually this would be done with a bundle
			
			contextBuilder.withContextView(this)
									.withDispatcher(this)
									.withInjector(new Injector())
									.withExtension(ViewManagerExtension)
									.withExtension(AutoStageListenerExtension)
									.withExtension(MediatorMapExtension)
									.withConfig(RL2MediatorsStrictConfig)
									.withConfig(ContextViewListenerConfig)
									.build();
		}	

		protected function addMappings(e:ContextBuilderEvent):void
		{
			const mediatorMap:IMediatorMap = e.context.injector.getInstance(IMediatorMap);
			mediatorMap.map(TracingMediator).toView(MovieClip);
			
			e.context.injector.map(MediatorWatcher).toValue(_mediatorWatcher);
		}
	}
}