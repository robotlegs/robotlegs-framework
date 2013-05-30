//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{
	import flash.utils.Dictionary;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.api.ILogger;
	import robotlegs.bender.framework.api.IMatcher;
	import robotlegs.bender.framework.api.LifecycleEvent;

	/**
	 * The config manager handles configuration files and
	 * allows the installation of custom configuration handlers.
	 *
	 * <p>It is pre-configured to handle plain objects and classes</p>
	 *
	 * @private
	 */
	public class ConfigManager
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _objectProcessor:ObjectProcessor = new ObjectProcessor();

		private const _configs:Dictionary = new Dictionary();

		private const _queue:Array = [];

		private var _injector:IInjector;

		private var _logger:ILogger;

		private var _initialized:Boolean;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * @private
		 */
		public function ConfigManager(context:IContext)
		{
			_injector = context.injector;
			_logger = context.getLogger(this);
			addConfigHandler(new ClassMatcher(), handleClass);
			addConfigHandler(new ObjectMatcher(), handleObject);
			// The ConfigManager should process the config queue
			// at the end of the INITIALIZE phase,
			// but *before* POST_INITIALIZE, so use low event priority
			context.addEventListener(LifecycleEvent.INITIALIZE, initialize, false, -100);
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * Process a given configuration object by running it through registered handlers.
		 * <p>If the manager is not initialized the configuration will be queued.</p>
		 * @param config The configuration object or class
		 */
		public function addConfig(config:Object):void
		{
			if (!_configs[config])
			{
				_configs[config] = true;
				_objectProcessor.processObject(config);
			}
		}

		/**
		 * Adds a custom configuration handlers
		 * @param matcher Pattern to match configuration objects
		 * @param handler Handler to process matching configurations
		 */
		public function addConfigHandler(matcher:IMatcher, handler:Function):void
		{
			_objectProcessor.addObjectHandler(matcher, handler);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function initialize(event:LifecycleEvent):void
		{
			if (!_initialized)
			{
				_initialized = true;
				processQueue();
			}
		}

		private function handleClass(type:Class):void
		{
			if (_initialized)
			{
				_logger.debug("Already initialized. Instantiating config class {0}", [type]);
				processClass(type);
			}
			else
			{
				_logger.debug("Not yet initialized. Queuing config class {0}", [type]);
				_queue.push(type);
			}
		}

		private function handleObject(object:Object):void
		{
			if (_initialized)
			{
				_logger.debug("Already initialized. Injecting into config object {0}", [object]);
				processObject(object);
			}
			else
			{
				_logger.debug("Not yet initialized. Queuing config object {0}", [object]);
				_queue.push(object);
			}
		}

		private function processQueue():void
		{
			for each (var config:Object in _queue)
			{
				if (config is Class)
				{
					_logger.debug("Now initializing. Instantiating config class {0}", [config]);
					processClass(config as Class);
				}
				else
				{
					_logger.debug("Now initializing. Injecting into config object {0}", [config]);
					processObject(config);
				}
			}
			_queue.length = 0;
		}

		private function processClass(type:Class):void
		{
			const config:IConfig = _injector.getOrCreateNewInstance(type) as IConfig;
			config && config.configure();
		}

		private function processObject(object:Object):void
		{
			_injector.injectInto(object);
			const config:IConfig = object as IConfig;
			config && config.configure();
		}
	}
}

import robotlegs.bender.framework.api.IMatcher;

/**
 * @private
 */
class ClassMatcher implements IMatcher
{

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function matches(item:*):Boolean
	{
		return item is Class;
	}
}

/**
 * @private
 */
class ObjectMatcher implements IMatcher
{

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function matches(item:*):Boolean
	{
		return item is Class == false;
	}
}
