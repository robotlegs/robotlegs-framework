//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.core.impl
{
	import flash.display.DisplayObjectContainer;
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.api.IContextConfig;
	import org.robotlegs.v2.core.api.IContextExtension;
	import org.swiftsuspenders.Injector;

	public class Context implements IContext
	{

		/*============================================================================*/
		/* Private Static Properties                                                  */
		/*============================================================================*/

		private static var counter:int;


		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _applicationDomain:ApplicationDomain;

		public function get applicationDomain():ApplicationDomain
		{
			return _applicationDomain;
		}


		private var _contextView:DisplayObjectContainer;

		public function get contextView():DisplayObjectContainer
		{
			return _contextView;
		}

		public function set contextView(value:DisplayObjectContainer):void
		{
			_initialized && throwContextLockedError();
			_contextView = value;
			logger.info('context view externally set to {0}', [value]);
		}

		private var _destroyed:Boolean;

		public function get destroyed():Boolean
		{
			return _destroyed;
		}

		private var _dispatcher:IEventDispatcher;

		public function get dispatcher():IEventDispatcher
		{
			return _dispatcher;
		}

		public function set dispatcher(value:IEventDispatcher):void
		{
			_initialized && throwContextLockedError();
			_dispatcher = value;
			logger.info('event dispatcher externally set to {0}', [value]);
		}

		private var _initialized:Boolean;

		public function get initialized():Boolean
		{
			return _initialized;
		}


		private var _injector:Injector;

		public function get injector():Injector
		{
			return _injector;
		}

		public function set injector(value:Injector):void
		{
			_initialized && throwContextLockedError();
			_injector = value;
			logger.info('injector externally set to {0}', [value]);
		}


		private var _parent:IContext;

		public function get parent():IContext
		{
			return _parent;
		}

		public function set parent(value:IContext):void
		{
			_initialized && throwContextLockedError();
			_parent = value;
			logger.info('parent context externally set to {0}', [value]);
		}

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _id:String = 'Context' + counter++;

		private const configs:Vector.<IContextConfig> = new Vector.<IContextConfig>;

		private const extensions:Vector.<IContextExtension> = new Vector.<IContextExtension>;

		private const logger:ILogger = getLogger(_id);

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function Context()
		{
			// This page intentionally left blank
		}


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function destroy():void
		{
			logger.info('destroying context');
			_destroyed && throwContextDestroyedError();
			uninstallExtensions();
			_destroyed = true;
		}

		public function initialize():void
		{
			logger.info('initializing context');
			_initialized && throwContextLockedError();
			_initialized = true;
			configureApplicationDomain();
			configureDispatcher();
			configureInjector();
			mapInjections();
			addContextToContextViewRegistry();
			installExtensions();
			initializeExtensions();
			initializeConfigs();
			logger.info('context initialization complete');
		}

		public function installExtension(extension:IContextExtension):void
		{
			logger.info('installing extension {0}', [extension]);
			_destroyed && throwContextDestroyedError();
			if (extensions.indexOf(extension) != -1)
				return;
			extensions.push(extension);
			if (initialized)
			{
				extension.install(this);
				extension.initialize(this);
			}
		}

		public function toString():String
		{
			return _id;
		}

		public function uninstallExtension(extension:IContextExtension):void
		{
			logger.info('uninstalling extension {0}', [extension]);
			_destroyed && throwContextDestroyedError();
			const index:int = extensions.indexOf(extension);
			if (index > -1)
			{
				extensions.splice(index, 1);
				extension.uninstall(this);
			}
		}

		public function withConfig(config:IContextConfig):void
		{
			_initialized && throwContextLockedError();
			logger.info('adding config {0}', [config]);
			configs.push(config);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function addContextToContextViewRegistry():void
		{
			logger.info('adding context to context view registry');
			if (contextView)
				ContextViewRegistry.getSingleton().addContext(this);
		}

		private function configureApplicationDomain():void
		{
			logger.info('configuring application domain');
			if (contextView && contextView.loaderInfo)
			{
				_applicationDomain = contextView.loaderInfo.applicationDomain;
			}
			else
			{
				_applicationDomain = ApplicationDomain.currentDomain;
			}
		}

		private function configureDispatcher():void
		{
			logger.info('configuring event dispatcher');
			_dispatcher ||= new EventDispatcher();
		}

		private function configureInjector():void
		{
			logger.info('configuring injector');

			_injector ||= createInjector();
		}

		private function createInjector():Injector
		{
			if (parent && parent.injector)
			{
				logger.info('getting child injector from parent');
				return parent.injector.createChildInjector(_applicationDomain);
			}
			return new Injector();
		}

		private function initializeConfigs():void
		{
			logger.info('initializing configs');
			configs.forEach(function(config:IContextConfig, ... rest):void
			{
				injector.injectInto(config);
				config.configure(this);
			}, this);
		}

		private function initializeExtensions():void
		{
			logger.info('initializing extensions');
			extensions.forEach(function(extension:IContextExtension, ... rest):void
			{
				extension.initialize(this);
			}, this);
		}

		private function installExtensions():void
		{
			logger.info('installing extensions');

			extensions.forEach(function(extension:IContextExtension, ... rest):void
			{
				extension.install(this);
			}, this);
		}

		private function mapInjections():void
		{
			logger.info('mapping injections');
			injector.map(IContext).toValue(this);
			injector.map(Injector).toValue(injector);
			injector.map(IEventDispatcher).toValue(dispatcher);
			injector.map(DisplayObjectContainer).toValue(contextView);
		}

		private function throwContextDestroyedError():void
		{
			const message:String = 'This context has been destroyed and is now dead';
			logger.fatal(message);
			throw new IllegalOperationError(message);
		}

		private function throwContextLockedError():void
		{
			const message:String = 'This context has already been initialized and is now locked';
			logger.fatal(message);
			throw new IllegalOperationError(message);
		}

		private function uninstallExtensions():void
		{
			logger.info('uninstalling extensions');
			// uninstall in reverse order
			var extension:IContextExtension;
			while (extension = extensions.pop())
			{
				extension.uninstall(this);
			}
		}
	}
}
