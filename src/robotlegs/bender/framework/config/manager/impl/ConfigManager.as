//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.config.manager.impl
{
	import org.hamcrest.Matcher;
	import org.hamcrest.object.instanceOf;
	import org.swiftsuspenders.DescribeTypeJSONReflector;
	import org.swiftsuspenders.Reflector;
	import robotlegs.bender.core.object.processor.api.IObjectProcessor;
	import robotlegs.bender.core.object.processor.impl.ObjectProcessor;
	import robotlegs.bender.framework.config.manager.api.IConfigManager;
	import robotlegs.bender.framework.context.api.IContext;
	import robotlegs.bender.framework.context.api.IContextConfig;
	import robotlegs.bender.framework.object.managed.impl.ManagedObject;

	public class ConfigManager implements IConfigManager
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _reflector:Reflector = new DescribeTypeJSONReflector();

		private const _objectProcessor:IObjectProcessor = new ObjectProcessor();

		private const _configs:Array = [];

		private const _plainClassConfigs:Array = [];

		private var _context:IContext;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function ConfigManager(context:IContext)
		{
			_context = context;
			configure();
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function addConfig(config:Object):void
		{
			if (!hasConfig(config))
			{
				_configs.push(config);
				_objectProcessor.addObject(config);
			}
		}

		public function addConfigHandler(matcher:Matcher, handler:Function):void
		{
			_objectProcessor.addObjectHandler(matcher, handler);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function configure():void
		{
			addConfigHandler(instanceOf(IContextConfig), handleContextConfig);
			addConfigHandler(instanceOf(Class), handleClass);
			_context.addStateHandler(ManagedObject.SELF_INITIALIZE, onContextSelfInitialize);
		}

		private function hasConfig(config:Object):Boolean
		{
			return _configs.indexOf(config) > -1;
		}

		private function handleContextConfig(config:IContextConfig):void
		{
			config.configureContext(_context);
		}

		private function handleClass(type:Class):void
		{
			if (_reflector.typeImplements(type, IContextConfig))
			{
				addConfig(new type());
			}
			else
			{
				handlePlainClass(type);
			}
		}

		private function handlePlainClass(type:Class):void
		{
			if (_context.initialized)
			{
				_context.injector.getInstance(type);
			}
			else
			{
				_plainClassConfigs.push(type);
			}
		}

		private function onContextSelfInitialize():void
		{
			for each (var configClass:Class in _plainClassConfigs)
			{
				_context.injector.getInstance(configClass);
			}
			_plainClassConfigs.length = 0;
		}
	}
}
