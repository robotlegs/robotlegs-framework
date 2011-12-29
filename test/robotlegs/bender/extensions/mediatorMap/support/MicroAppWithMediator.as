//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.support
{
	import robotlegs.bender.core.impl.ContextBuilder;
	import flash.display.Sprite;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import flash.display.MovieClip;
	import robotlegs.bender.extensions.mediatorMap.support.TracingMediator;
	import robotlegs.bender.core.api.ContextBuilderEvent;
	import robotlegs.bender.extensions.mediatorMap.impl.support.MediatorWatcher;
	import robotlegs.bender.extensions.mediatorMap.bundles.RL2MediatorsMediatorMapBundle;

	public class MicroAppWithMediator extends Sprite
	{

		protected var _mediatorWatcher:MediatorWatcher;

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
									.withBundle(RL2MediatorsMediatorMapBundle)
									.build();
		}

		protected function addMappings(e:ContextBuilderEvent):void
		{
			const mediatorMap:IMediatorMap = e.context.injector.getInstance(IMediatorMap);
			mediatorMap.map(MovieClip).toMediator(TracingMediator);

			e.context.injector.map(MediatorWatcher).toValue(_mediatorWatcher);
		}
	}
}