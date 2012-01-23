//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.configManager.impl
{
	import flash.display.DisplayObject;
	import org.hamcrest.Matcher;
	import org.hamcrest.core.allOf;
	import org.hamcrest.core.not;
	import org.hamcrest.object.instanceOf;
	import org.swiftsuspenders.DescribeTypeJSONReflector;
	import org.swiftsuspenders.Reflector;
	import robotlegs.bender.core.objectProcessor.api.IObjectProcessor;
	import robotlegs.bender.core.objectProcessor.impl.ObjectProcessor;
	import robotlegs.bender.framework.configManager.api.IConfigManager;
	import robotlegs.bender.framework.context.api.IContext;
	import robotlegs.bender.framework.context.api.IContextConfig;
	import robotlegs.bender.framework.logging.api.ILogger;
	import robotlegs.bender.framework.object.identity.UID;
	import robotlegs.bender.framework.object.managed.impl.ManagedObject;

	public class ConfigManager implements IConfigManager
	{

		/*============================================================================*/
		/* Private Static Properties                                                  */
		/*============================================================================*/

		private static const plainObjectMatcher:Matcher = allOf(
			instanceOf(Object),
			not(instanceOf(Class)),
			not(instanceOf(IContextConfig)),
			not(instanceOf(DisplayObject)));

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _uid:String = UID.create(ConfigManager);

		private const _reflector:Reflector = new DescribeTypeJSONReflector();

		private const _objectProcessor:IObjectProcessor = new ObjectProcessor();

		private const _configs:Array = [];

		private const _plainClassConfigs:Array = [];

		private const _plainObjectConfigs:Array = [];

		private var _context:IContext;

		private var _logger:ILogger;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function ConfigManager(context:IContext)
		{
			_context = context;
			_logger = _context.getLogger(this);
			addDefaultHandlers();
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

		public function toString():String
		{
			return _uid;
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function addDefaultHandlers():void
		{
			addConfigHandler(instanceOf(IContextConfig), handleContextConfig);
			// todo: make a classOf(IContextConfig) matcher
			addConfigHandler(instanceOf(Class), handleClass);
			addConfigHandler(plainObjectMatcher, handleObject);
			_context.addStateHandler(ManagedObject.SELF_INITIALIZE, onContextSelfInitialize);
		}

		private function hasConfig(config:Object):Boolean
		{
			return _configs.indexOf(config) > -1;
		}

		private function handleContextConfig(config:IContextConfig):void
		{
			_logger.debug("Installing IContextConfig {0}", [config]);
			config.configureContext(_context);
		}

		private function handleClass(type:Class):void
		{
			// todo: this can be replaced by a classOf(type) matcher
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
				_logger.debug("Context alread initialized. Instantiating plain class {0}", [type]);
				_context.injector.getInstance(type);
			}
			else
			{
				_logger.debug("Context not initialized. Queuing plain class {0}", [type]);
				_plainClassConfigs.push(type);
			}
		}

		private function handleObject(object:Object):void
		{
			if (_context.initialized)
			{
				_logger.debug("Context alread initialized. Injecting into plain object {0}", [object]);
				_context.injector.injectInto(object);
			}
			else
			{
				_logger.debug("Context not initialized. Queuing plain object {0}", [object]);
				_plainObjectConfigs.push(object);
			}
		}

		private function onContextSelfInitialize():void
		{
			for each (var configClass:Class in _plainClassConfigs)
			{
				_logger.debug("Context initializing. Instantiating plain class {0}", [configClass]);
				_context.injector.getInstance(configClass);
			}
			for each (var configObject:Object in _plainObjectConfigs)
			{
				_logger.debug("Context initializing. Injecting into plain object {0}", [configObject]);
				_context.injector.injectInto(configObject);
			}
			_plainClassConfigs.length = 0;
			_plainObjectConfigs.length = 0;
		}
	}
}
