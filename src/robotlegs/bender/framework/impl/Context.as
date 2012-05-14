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
	import robotlegs.bender.framework.api.ILogTarget;
	import robotlegs.bender.framework.api.ILogger;

	public class Context implements IContext
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private const _injector:Injector = new Injector();

		/**
		 * @inheritDoc
		 */
		public function get injector():Injector
		{
			return _injector;
		}

		/**
		 * @inheritDoc
		 */
		public function get logLevel():uint
		{
			return _logManager.logLevel;
		}

		/**
		 * @inheritDoc
		 */
		public function set logLevel(value:uint):void
		{
			_logManager.logLevel = value;
		}

		private var _lifecycle:Lifecycle;

		/**
		 * @inheritDoc
		 */
		public function get lifecycle():ILifecycle
		{
			return _lifecycle;
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
			setup();
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function initialize():void
		{
			_lifecycle.initialize();
		}

		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
			_lifecycle.destroy();
		}

		/**
		 * @inheritDoc
		 */
		public function extend(... extensions):IContext
		{
			for each (var extension:Object in extensions)
			{
				_extensionInstaller.install(extension);
			}
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function configure(... configs):IContext
		{
			for each (var config:Object in configs)
			{
				_configManager.addConfig(config);
			}
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function addConfigHandler(matcher:Matcher, handler:Function):IContext
		{
			_configManager.addConfigHandler(matcher, handler);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function getLogger(source:Object):ILogger
		{
			return _logManager.getLogger(source);
		}

		/**
		 * @inheritDoc
		 */
		public function addLogTarget(target:ILogTarget):IContext
		{
			_logManager.addLogTarget(target);
			return this;
		}

		public function toString():String
		{
			return _uid;
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function setup():void
		{
			_injector.map(Injector).toValue(_injector);
			_injector.map(IContext).toValue(this);
			_logger = _logManager.getLogger(this);
			_lifecycle = new Lifecycle(this);
			_configManager = new ConfigManager(this);
			_extensionInstaller = new ExtensionInstaller(this);
			_lifecycle.beforeInitializing(beforeInitializing);
			_lifecycle.afterInitializing(afterInitializing);
			_lifecycle.beforeDestroying(beforeDestroying);
			_lifecycle.afterDestroying(afterDestroying);
		}

		private function beforeInitializing():void
		{
			_logger.info("Initializing...");
		}

		private function afterInitializing():void
		{
			_logger.info("Initialize complete");
		}

		private function beforeDestroying():void
		{
			_logger.info("Destroying...");
		}

		private function afterDestroying():void
		{
			_logger.info("Destroy complete");
		}
	}
}
