//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.context.impl
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	import org.hamcrest.Matcher;
	import org.hamcrest.core.allOf;
	import org.hamcrest.core.not;
	import org.hamcrest.object.instanceOf;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.core.objectProcessor.api.IObjectProcessor;
	import robotlegs.bender.core.objectProcessor.impl.ObjectProcessor;
	import robotlegs.bender.framework.context.api.IContext;
	import robotlegs.bender.framework.logging.api.ILogger;

	public class ConfigManager
	{

		/*============================================================================*/
		/* Private Static Properties                                                  */
		/*============================================================================*/

		private static const plainObjectMatcher:Matcher = allOf(
			instanceOf(Object),
			not(instanceOf(Class)),
			not(instanceOf(DisplayObject)));

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _uid:String = UID.create(ConfigManager);

		private const _objectProcessor:IObjectProcessor = new ObjectProcessor();

		private const _configs:Dictionary = new Dictionary();

		private const _queue:Array = [];

		private var _injector:Injector;

		private var _logger:ILogger;

		private var _initialized:Boolean;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function ConfigManager(context:IContext)
		{
			_injector = context.injector;
			_logger = context.getLogger(this);
			addConfigHandler(instanceOf(Class), handleClass);
			addConfigHandler(plainObjectMatcher, handleObject);
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function addConfig(config:Object):void
		{
			if (!_configs[config])
			{
				_configs[config] = true;
				_objectProcessor.processObject(config);
			}
		}

		public function addConfigHandler(matcher:Matcher, handler:Function):void
		{
			_objectProcessor.addObjectHandler(matcher, handler);
		}

		public function initialize():void
		{
			if (!_initialized)
			{
				_initialized = true;
				processQueue();
			}
		}

		public function toString():String
		{
			return _uid;
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function handleClass(type:Class):void
		{
			if (_initialized)
			{
				_logger.debug("Already initialized. Instantiating config class {0}", [type]);
				_injector.getInstance(type);
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
				_injector.injectInto(object);
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
					_injector.getInstance(config as Class);
				}
				else
				{
					_logger.debug("Now initializing. Injecting into config object {0}", [config]);
					_injector.injectInto(config);
				}
			}
			_queue.length = 0;
		}
	}
}
