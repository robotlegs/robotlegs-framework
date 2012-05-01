//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{
	import org.hamcrest.Matcher;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.ILifecycle;
	import robotlegs.bender.framework.api.LifecycleState;
	import robotlegs.bender.framework.api.ILogTarget;
	import robotlegs.bender.framework.api.ILogger;

	public class Context implements IContext
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private const _injector:Injector = new Injector();

		public function get injector():Injector
		{
			return _injector;
		}

		public function get logLevel():uint
		{
			return _logManager.logLevel;
		}

		public function set logLevel(value:uint):void
		{
			_logManager.logLevel = value;
		}

		private var _lifecycle:Lifecycle;

		public function get lifecycle():ILifecycle
		{
			return _lifecycle;
		}

		// todo: move this into lifecycle
		public function get initialized():Boolean
		{
			return _lifecycle.state != LifecycleState.UNINITIALIZED
					&& _lifecycle.state != LifecycleState.INITIALIZING;
		}

		// todo: move this into lifecycle
		public function get destroyed():Boolean
		{
			return _lifecycle.state == LifecycleState.DESTROYED;
		}

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _uid:String = UID.create(Context);

		private const _logManager:LogManager = new LogManager();

		private var _configManager:ConfigManager;

		private var _extensionInstaller:ExtensionInstaller;

		private var _logger:ILogger;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function Context()
		{
			_injector.map(Injector).toValue(_injector);
			_injector.map(IContext).toValue(this);
			_logger = _logManager.getLogger(this);
			_lifecycle = new Lifecycle(this);
			_configManager = new ConfigManager(this);
			_extensionInstaller = new ExtensionInstaller(this);
			_lifecycle.whenInitializing(_configManager.initialize);
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function initialize():void
		{
			_logger.info("Initializing...");
			_lifecycle.initialize(handleInitializeComplete);
		}

		public function destroy():void
		{
			_logger.info("Destroying...");
			_lifecycle.destroy(handleDestroyComplete);
		}

		public function extend(... extensions):IContext
		{
			for each (var extension:Object in extensions)
			{
				_extensionInstaller.install(extension);
			}
			return this;
		}

		public function configure(... configs):IContext
		{
			for each (var config:Object in configs)
			{
				_configManager.addConfig(config);
			}
			return this;
		}

		public function addConfigHandler(matcher:Matcher, handler:Function):IContext
		{
			_configManager.addConfigHandler(matcher, handler);
			return this;
		}

		public function getLogger(source:Object):ILogger
		{
			return _logManager.getLogger(source);
		}

		public function addLogTarget(target:ILogTarget):void
		{
			_logManager.addLogTarget(target);
		}

		public function toString():String
		{
			return _uid;
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function handleInitializeComplete(error:Object):void
		{
			error && handleError(error);
			_logger.info("Initialize complete");
		}

		private function handleDestroyComplete(error:Object):void
		{
			error && handleError(error);
			_logger.info("Destroy complete");
		}

		private function handleError(error:Object):void
		{
			_logger.error(error);
			if (error is Error)
			{
				throw error as Error;
			}
			else if (error)
			{
				throw new Error(error);
			}
		}
	}
}
