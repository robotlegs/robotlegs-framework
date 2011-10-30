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
	import flash.utils.Dictionary;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.api.IContextConfig;
	import org.robotlegs.v2.core.api.IContextExtension;
	import org.swiftsuspenders.Injector;

	public class Context implements IContext
	{

		private static var counter:int;

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

		private const _id:String = 'Context' + counter++;

		private const configClasses:Vector.<Class> = new Vector.<Class>;

		private const extensionByClass:Dictionary = new Dictionary();

		private const extensionClasses:Vector.<Class> = new Vector.<Class>;

		private const logger:ILogger = getLogger(_id);

		public function Context()
		{
			// This page intentionally left blank
		}

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

		public function installExtension(extensionClass:Class):IContext
		{
			logger.info('installing extension {0}', [extensionClass]);
			_destroyed && throwContextDestroyedError();
			if (extensionClasses.indexOf(extensionClass) != -1)
				return this;

			extensionClasses.push(extensionClass);

			if (initialized)
			{
				const extension:IContextExtension = createExtension(extensionClass);
				extension.install(this);
				extension.initialize(this);
			}

			return this;
		}

		public function toString():String
		{
			return _id;
		}

		public function uninstallExtension(extensionClass:Class):IContext
		{
			logger.info('uninstalling extension {0}', [extensionClass]);
			_destroyed && throwContextDestroyedError();
			const index:int = extensionClasses.indexOf(extensionClass);
			if (index == -1)
				return this;

			extensionClasses.splice(index, 1);

			const extension:IContextExtension = extensionByClass[extensionClass];
			extension && extension.uninstall(this);

			return this;
		}

		public function withConfig(configClass:Class):IContext
		{
			_initialized && throwContextLockedError();
			logger.info('adding config {0}', [configClass]);
			configClasses.push(configClass);
			return this;
		}

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

		private function createExtension(extensionClass:Class):IContextExtension
		{
			const extension:IContextExtension = injector.getInstance(extensionClass);
			extensionByClass[extensionClass] = extension;
			return extension;
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
			configClasses.forEach(function(configClass:Class, ... rest):void
			{
				var config:IContextConfig = injector.getInstance(configClass);
				config.configure(this);
			}, this);
		}

		private function initializeExtensions():void
		{
			logger.info('initializing extensions');
			extensionClasses.forEach(function(extensionClass:Class, ... rest):void
			{
				const extension:IContextExtension = extensionByClass[extensionClass]
				extension.initialize(this);
			}, this);
		}

		private function installExtensions():void
		{
			logger.info('installing extensions');

			extensionClasses.forEach(function(extensionClass:Class, ... rest):void
			{
				const extension:IContextExtension = createExtension(extensionClass);
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
			var extensionClass:Class;
			while (extensionClass = extensionClasses.pop())
			{
				const extension:IContextExtension = extensionByClass[extensionClass];
				extension.uninstall(this);
			}
		}
	}
}
