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
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.api.IContextLogger;
	import org.swiftsuspenders.Injector;

	public class Context implements IContext
	{
		private static var counter:uint;

		private const _id:String = 'Context' + counter++;

		public function get id():String
		{
			return _id;
		}

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
			logger.info(this, 'Context view externally set to: {0}', [value]);
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
			logger.info(this, 'Event dispatcher externally set to: {0}', [value]);
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
			logger.info(this, 'Injector externally set to: {0}', [value]);
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
			logger.info(this, 'Parent context externally set to: {0}', [value]);
		}

		private var _logger:IContextLogger;

		public function get logger():IContextLogger
		{
			return _logger;
		}

		private var extensionManager:ExtensionManager;

		private var configManager:ConfigManager;

		public function Context()
		{
			_logger = new ContextLogger(this);
			extensionManager = new ExtensionManager(this);
			configManager = new ConfigManager(this);
		}

		public function destroy():void
		{
			_destroyed && throwContextDestroyedError();
			_destroyed = true;
			logger.info(this, 'Destroying context.');
			configManager.destroy();
			extensionManager.destroy();
		}

		public function initialize():void
		{
			_initialized && throwContextLockedError();
			_initialized = true;
			logger.info(this, 'Initializing context.');
			configureApplicationDomain();
			configureDispatcher();
			configureInjector();
			mapInjections();
			addContextToContextViewRegistry();
			extensionManager.initialize();
			configManager.initialize();
			logger.info(this, 'Context initialization complete.');
		}

		public function installExtension(extensionClass:Class):IContext
		{
			_destroyed && throwContextDestroyedError();
			logger.info(this, 'Installing extension: {0}', [extensionClass]);
			extensionManager.addExtension(extensionClass);
			return this;
		}

		public function toString():String
		{
			return _id;
		}

		public function uninstallExtension(extensionClass:Class):IContext
		{
			_destroyed && throwContextDestroyedError();
			logger.info(this, 'Uninstalling extension: {0}', [extensionClass]);
			extensionManager.removeExtension(extensionClass);
			return this;
		}

		public function withConfig(configClass:Class):IContext
		{
			_initialized && throwContextLockedError();
			logger.info(this, 'Adding config: {0}', [configClass]);
			configManager.addConfig(configClass);
			return this;
		}

		private function addContextToContextViewRegistry():void
		{
			logger.info(this, 'Adding context to context view registry.');
			if (contextView)
				ContextViewRegistry.getSingleton().addContext(this);
		}

		private function configureApplicationDomain():void
		{
			logger.info(this, 'Configuring application domain');
			if (contextView && contextView.loaderInfo)
			{
				logger.info(this, 'Configuring application domain based on contextView loaderInfo.');
				_applicationDomain = contextView.loaderInfo.applicationDomain;
			}
			else
			{
				logger.info(this, 'Configuring application domain using currentDomain.');
				_applicationDomain = ApplicationDomain.currentDomain;
			}
		}

		private function configureDispatcher():void
		{
			logger.info(this, 'Configuring event dispatcher.');
			_dispatcher ||= new EventDispatcher();
		}

		private function configureInjector():void
		{
			logger.info(this, 'Configuring injector.');
			_injector ||= createInjector();
		}

		private function createInjector():Injector
		{
			if (parent && parent.injector)
			{
				logger.info(this, 'Creating child injector from parent context.');
				return parent.injector.createChildInjector(_applicationDomain);
			}
			logger.info(this, 'Creating new injector. Note: this injector will not inherit any rules.');
			return new Injector();
		}

		private function mapInjections():void
		{
			logger.info(this, 'Mapping default injections.');
			injector.map(IContext).toValue(this);
			injector.map(Injector).toValue(injector);
			injector.map(IEventDispatcher).toValue(dispatcher);
			injector.map(DisplayObjectContainer).toValue(contextView);
			injector.map(IContextLogger).toValue(logger);
		}

		private function throwContextDestroyedError():void
		{
			const message:String = 'This context has been destroyed and is now dead.';
			logger.fatal(this, message);
			throw new IllegalOperationError(message);
		}

		private function throwContextLockedError():void
		{
			const message:String = 'This context has already been initialized and is now locked.';
			logger.fatal(this, message);
			throw new IllegalOperationError(message);
		}
	}
}
