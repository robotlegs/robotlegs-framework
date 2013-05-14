//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.modularity.impl
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.modularity.api.IModuleConnector;
	import robotlegs.bender.extensions.modularity.dsl.IModuleConnectionAction;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.impl.getRootInjector;

	public class ModuleConnector implements IModuleConnector
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _rootInjector:Injector;

		private var _localDispatcher:IEventDispatcher;

		private var _configuratorsByChannel:Object = {};

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function ModuleConnector(context:IContext)
		{
			const injector:Injector = context.injector;
			_rootInjector = getRootInjector(injector);
			_localDispatcher = injector.getInstance(IEventDispatcher);
			context.whenDestroying(destroy);
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function onChannel(channelId:String):IModuleConnectionAction
		{
			return getOrCreateConfigurator(channelId);
		}

		public function globally():IModuleConnectionAction
		{
			return getOrCreateConfigurator('global');
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function destroy():void
		{
			for (var channelId:String in _configuratorsByChannel)
			{
				const configurator:ModuleConnectionConfigurator = _configuratorsByChannel[channelId];
				configurator.destroy();
				delete _configuratorsByChannel[channelId];
			}

			_configuratorsByChannel = null;
			_localDispatcher = null;
			_rootInjector = null;
		}

		private function getOrCreateConfigurator(channelId:String):ModuleConnectionConfigurator
		{
			return _configuratorsByChannel[channelId] ||= createConfigurator(channelId);
		}

		private function createConfigurator(channelId:String):ModuleConnectionConfigurator
		{
			if (!_rootInjector.hasMapping(IEventDispatcher, channelId))
			{
				_rootInjector.map(IEventDispatcher, channelId)
					.toValue(new EventDispatcher());
			}
			return new ModuleConnectionConfigurator(_localDispatcher, _rootInjector.getInstance(IEventDispatcher, channelId));
		}
	}
}
