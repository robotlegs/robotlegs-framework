//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{
	import flash.events.EventDispatcher;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.api.ILogTarget;
	import robotlegs.bender.framework.api.ILogger;
	import robotlegs.bender.framework.api.IMatcher;
	import robotlegs.bender.framework.api.LifecycleEvent;

	[Event(name="destroy", type="robotlegs.bender.framework.api.LifecycleEvent")]
	[Event(name="detain", type="robotlegs.bender.framework.api.PinEvent")]
	[Event(name="initialize", type="robotlegs.bender.framework.api.LifecycleEvent")]
	[Event(name="postDestroy", type="robotlegs.bender.framework.api.LifecycleEvent")]
	[Event(name="postInitialize", type="robotlegs.bender.framework.api.LifecycleEvent")]
	[Event(name="postResume", type="robotlegs.bender.framework.api.LifecycleEvent")]
	[Event(name="postSuspend", type="robotlegs.bender.framework.api.LifecycleEvent")]
	[Event(name="preDestroy", type="robotlegs.bender.framework.api.LifecycleEvent")]
	[Event(name="preInitialize", type="robotlegs.bender.framework.api.LifecycleEvent")]
	[Event(name="preResume", type="robotlegs.bender.framework.api.LifecycleEvent")]
	[Event(name="preSuspend", type="robotlegs.bender.framework.api.LifecycleEvent")]
	[Event(name="release", type="robotlegs.bender.framework.api.PinEvent")]
	[Event(name="resume", type="robotlegs.bender.framework.api.LifecycleEvent")]
	[Event(name="stateChange", type="robotlegs.bender.framework.api.LifecycleEvent")]
	[Event(name="suspend", type="robotlegs.bender.framework.api.LifecycleEvent")]
	/**
	 * The core Robotlegs Context implementation
	 */
	public class Context extends EventDispatcher implements IContext
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private const _injector:IInjector = new RobotlegsInjector();

		/**
		 * @inheritDoc
		 */
		public function get injector():IInjector
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

		[Bindable("stateChange")]
		/**
		 * @inheritDoc
		 */
		public function get state():String
		{
			return _lifecycle.state;
		}

		/**
		 * @inheritDoc
		 */
		public function get uninitialized():Boolean
		{
			return _lifecycle.uninitialized;
		}

		/**
		 * @inheritDoc
		 */
		public function get initialized():Boolean
		{
			return _lifecycle.initialized;
		}

		/**
		 * @inheritDoc
		 */
		public function get active():Boolean
		{
			return _lifecycle.active;
		}

		/**
		 * @inheritDoc
		 */
		public function get suspended():Boolean
		{
			return _lifecycle.suspended;
		}

		/**
		 * @inheritDoc
		 */
		public function get destroyed():Boolean
		{
			return _lifecycle.destroyed;
		}

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _uid:String = UID.create(Context);

		private const _logManager:LogManager = new LogManager();

		private const _children:Array = [];

		private var _pin:Pin;

		private var _lifecycle:Lifecycle;

		private var _configManager:ConfigManager;

		private var _extensionInstaller:ExtensionInstaller;

		private var _logger:ILogger;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * Creates a new Context
		 */
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
		public function initialize(callback:Function = null):void
		{
			_lifecycle.initialize(callback);
		}

		/**
		 * @inheritDoc
		 */
		public function suspend(callback:Function = null):void
		{
			_lifecycle.suspend(callback);
		}

		/**
		 * @inheritDoc
		 */
		public function resume(callback:Function = null):void
		{
			_lifecycle.resume(callback);
		}

		/**
		 * @inheritDoc
		 */
		public function destroy(callback:Function = null):void
		{
			_lifecycle.destroy(callback);
		}

		/**
		 * @inheritDoc
		 */
		public function beforeInitializing(handler:Function):IContext
		{
			_lifecycle.beforeInitializing(handler);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function whenInitializing(handler:Function):IContext
		{
			_lifecycle.whenInitializing(handler);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function afterInitializing(handler:Function):IContext
		{
			_lifecycle.afterInitializing(handler);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function beforeSuspending(handler:Function):IContext
		{
			_lifecycle.beforeSuspending(handler);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function whenSuspending(handler:Function):IContext
		{
			_lifecycle.whenSuspending(handler);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function afterSuspending(handler:Function):IContext
		{
			_lifecycle.afterSuspending(handler);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function beforeResuming(handler:Function):IContext
		{
			_lifecycle.beforeResuming(handler);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function whenResuming(handler:Function):IContext
		{
			_lifecycle.whenResuming(handler);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function afterResuming(handler:Function):IContext
		{
			_lifecycle.afterResuming(handler);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function beforeDestroying(handler:Function):IContext
		{
			_lifecycle.beforeDestroying(handler);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function whenDestroying(handler:Function):IContext
		{
			_lifecycle.whenDestroying(handler);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function afterDestroying(handler:Function):IContext
		{
			_lifecycle.afterDestroying(handler);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function install(... extensions):IContext
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
		public function addChild(child:IContext):IContext
		{
			if (_children.indexOf(child) == -1)
			{
				_logger.info("Adding child context {0}", [child]);
				if (!child.uninitialized)
				{
					_logger.warn("Child context {0} must be uninitialized", [child]);
				}
				if (child.injector.parent)
				{
					_logger.warn("Child context {0} must not have a parent Injector", [child]);
				}
				_children.push(child);
				child.injector.parent = injector;
				child.addEventListener(LifecycleEvent.POST_DESTROY, onChildDestroy);
			}
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function removeChild(child:IContext):IContext
		{
			const childIndex:int = _children.indexOf(child);
			if (childIndex > -1)
			{
				_logger.info("Removing child context {0}", [child]);
				_children.splice(childIndex, 1);
				child.injector.parent = null;
				child.removeEventListener(LifecycleEvent.POST_DESTROY, onChildDestroy);
			}
			else
			{
				_logger.warn("Child context {0} must be a child of {1}", [child, this]);
			}
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function addConfigHandler(matcher:IMatcher, handler:Function):IContext
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

		/**
		 * @inheritDoc
		 */
		public function detain(... instances):IContext
		{
			for each (var instance:Object in instances)
			{
				_pin.detain(instance);
			}
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function release(... instances):IContext
		{
			for each (var instance:Object in instances)
			{
				_pin.release(instance);
			}
			return this;
		}

		/**
		 * @inheritDoc
		 */
		override public function toString():String
		{
			return _uid;
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		/**
		 * Configures mandatory context dependencies
		 */
		private function setup():void
		{
			_injector.map(IInjector).toValue(_injector);
			_injector.map(IContext).toValue(this);
			_logger = _logManager.getLogger(this);
			_pin = new Pin(this);
			_lifecycle = new Lifecycle(this);
			_configManager = new ConfigManager(this);
			_extensionInstaller = new ExtensionInstaller(this);
			beforeInitializing(beforeInitializingCallback);
			afterInitializing(afterInitializingCallback);
			beforeDestroying(beforeDestroyingCallback);
			afterDestroying(afterDestroyingCallback);
		}

		private function beforeInitializingCallback():void
		{
			_logger.info("Initializing...");
		}

		private function afterInitializingCallback():void
		{
			_logger.info("Initialize complete");
		}

		private function beforeDestroyingCallback():void
		{
			_logger.info("Destroying...");
		}

		private function afterDestroyingCallback():void
		{
			_pin.releaseAll();
			_injector.teardown();
			removeChildren();
			_logger.info("Destroy complete");
		}

		private function onChildDestroy(event:LifecycleEvent):void
		{
			removeChild(event.target as IContext);
		}

		private function removeChildren():void
		{
			for each (var child:IContext in _children.concat())
			{
				removeChild(child);
			}
			_children.splice(0);
		}
	}
}
