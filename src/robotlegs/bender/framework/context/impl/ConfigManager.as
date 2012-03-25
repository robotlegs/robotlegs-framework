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
	import robotlegs.bender.core.objectProcessor.api.IObjectProcessor;
	import robotlegs.bender.core.objectProcessor.impl.ObjectProcessor;
	import robotlegs.bender.framework.context.api.IContext;
	import robotlegs.bender.framework.logging.api.ILogger;
	import robotlegs.bender.framework.object.identity.UID;
	import robotlegs.bender.framework.object.managed.impl.ManagedObject;

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

		private var _context:IContext;

		private var _logger:ILogger;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function ConfigManager(context:IContext)
		{
			_context = context;
			_logger = _context.getLogger(this);
			// no! not from inside. add these externally
			addDefaultHandlers();
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function addConfig(config:Object):void
		{
			if (!_configs[config])
			{
				_configs[config] = true;
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
			addConfigHandler(instanceOf(Class), handleClass);
			addConfigHandler(plainObjectMatcher, handleObject);
			// todo: no! this is horrid. call something like: configManager.initialize()
			// which in turn removes the dependency on IContext
			// we only need the injector in that case
			_context.addStateHandler(ManagedObject.SELF_INITIALIZE, onContextSelfInitialize);
		}

		private function handleClass(type:Class):void
		{
			if (_context.initialized)
			{
				_logger.debug("Context already initialized. Instantiating config class {0}", [type]);
				_context.injector.getInstance(type);
			}
			else
			{
				_logger.debug("Context not yet initialized. Queuing config class {0}", [type]);
				_queue.push(type);
			}
		}

		private function handleObject(object:Object):void
		{
			if (_context.initialized)
			{
				_logger.debug("Context already initialized. Injecting into config object {0}", [object]);
				_context.injector.injectInto(object);
			}
			else
			{
				_logger.debug("Context not yet initialized. Queuing config object {0}", [object]);
				_queue.push(object);
			}
		}

		private function onContextSelfInitialize():void
		{
			for each (var config:Object in _queue)
			{
				if (config is Class)
				{
					_logger.debug("Context initializing. Instantiating config class {0}", [config]);
					_context.injector.getInstance(config as Class);
				}
				else
				{
					_logger.debug("Context initializing. Injecting into config object {0}", [config]);
					_context.injector.injectInto(config);
				}
			}
			_queue.length = 0;
		}
	}
}
