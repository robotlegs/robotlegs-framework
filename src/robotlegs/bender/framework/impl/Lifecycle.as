//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import robotlegs.bender.framework.api.ILifecycle;
	import robotlegs.bender.framework.api.LifecycleEvent;
	import robotlegs.bender.framework.api.LifecycleState;

	[Event(name="destroy", type="robotlegs.bender.framework.api.LifecycleEvent")]
	[Event(name="error", type="robotlegs.bender.framework.api.LifecycleEvent")]
	[Event(name="initialize", type="robotlegs.bender.framework.api.LifecycleEvent")]
	[Event(name="postDestroy", type="robotlegs.bender.framework.api.LifecycleEvent")]
	[Event(name="postInitialize", type="robotlegs.bender.framework.api.LifecycleEvent")]
	[Event(name="postResume", type="robotlegs.bender.framework.api.LifecycleEvent")]
	[Event(name="postSuspend", type="robotlegs.bender.framework.api.LifecycleEvent")]
	[Event(name="preDestroy", type="robotlegs.bender.framework.api.LifecycleEvent")]
	[Event(name="preInitialize", type="robotlegs.bender.framework.api.LifecycleEvent")]
	[Event(name="preResume", type="robotlegs.bender.framework.api.LifecycleEvent")]
	[Event(name="preSuspend", type="robotlegs.bender.framework.api.LifecycleEvent")]
	[Event(name="resume", type="robotlegs.bender.framework.api.LifecycleEvent")]
	[Event(name="stateChange", type="robotlegs.bender.framework.api.LifecycleEvent")]
	[Event(name="suspend", type="robotlegs.bender.framework.api.LifecycleEvent")]
	/**
	 * Default object lifecycle
	 *
	 * @private
	 */
	public class Lifecycle extends EventDispatcher implements ILifecycle
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _state:String = LifecycleState.UNINITIALIZED;

		[Bindable("stateChange")]
		/**
		 * @inheritDoc
		 */
		public function get state():String
		{
			return _state;
		}

		private var _target:Object;

		/**
		 * @inheritDoc
		 */
		public function get target():Object
		{
			return _target;
		}

		/**
		 * @inheritDoc
		 */
		public function get uninitialized():Boolean
		{
			return _state == LifecycleState.UNINITIALIZED;
		}

		/**
		 * @inheritDoc
		 */
		public function get initialized():Boolean
		{
			return _state != LifecycleState.UNINITIALIZED
				&& _state != LifecycleState.INITIALIZING;
		}

		/**
		 * @inheritDoc
		 */
		public function get active():Boolean
		{
			return _state == LifecycleState.ACTIVE;
		}

		/**
		 * @inheritDoc
		 */
		public function get suspended():Boolean
		{
			return _state == LifecycleState.SUSPENDED;
		}

		/**
		 * @inheritDoc
		 */
		public function get destroyed():Boolean
		{
			return _state == LifecycleState.DESTROYED;
		}

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _reversedEventTypes:Dictionary = new Dictionary();

		private var _reversePriority:int;

		private var _initialize:LifecycleTransition;

		private var _suspend:LifecycleTransition;

		private var _resume:LifecycleTransition;

		private var _destroy:LifecycleTransition;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * Creates a lifecycle for a given target object
		 * @param target The target object
		 */
		public function Lifecycle(target:Object)
		{
			_target = target;
			configureTransitions();
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function initialize(callback:Function = null):void
		{
			_initialize.enter(callback);
		}

		/**
		 * @inheritDoc
		 */
		public function suspend(callback:Function = null):void
		{
			_suspend.enter(callback);
		}

		/**
		 * @inheritDoc
		 */
		public function resume(callback:Function = null):void
		{
			_resume.enter(callback);
		}

		/**
		 * @inheritDoc
		 */
		public function destroy(callback:Function = null):void
		{
			_destroy.enter(callback);
		}

		/**
		 * @inheritDoc
		 */
		public function beforeInitializing(handler:Function):ILifecycle
		{
			_initialize.addBeforeHandler(handler);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function beforeSuspending(handler:Function):ILifecycle
		{
			_suspend.addBeforeHandler(handler);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function beforeResuming(handler:Function):ILifecycle
		{
			_resume.addBeforeHandler(handler);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function beforeDestroying(handler:Function):ILifecycle
		{
			_destroy.addBeforeHandler(handler);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function whenInitializing(handler:Function):ILifecycle
		{
			addEventListener(LifecycleEvent.INITIALIZE, createLifecycleListener(handler, true));
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function whenSuspending(handler:Function):ILifecycle
		{
			addEventListener(LifecycleEvent.SUSPEND, createLifecycleListener(handler));
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function whenResuming(handler:Function):ILifecycle
		{
			addEventListener(LifecycleEvent.RESUME, createLifecycleListener(handler));
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function whenDestroying(handler:Function):ILifecycle
		{
			addEventListener(LifecycleEvent.DESTROY, createLifecycleListener(handler, true));
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function afterInitializing(handler:Function):ILifecycle
		{
			addEventListener(LifecycleEvent.POST_INITIALIZE, createLifecycleListener(handler, true));
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function afterSuspending(handler:Function):ILifecycle
		{
			addEventListener(LifecycleEvent.POST_SUSPEND, createLifecycleListener(handler));
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function afterResuming(handler:Function):ILifecycle
		{
			addEventListener(LifecycleEvent.POST_RESUME, createLifecycleListener(handler));
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function afterDestroying(handler:Function):ILifecycle
		{
			addEventListener(LifecycleEvent.POST_DESTROY, createLifecycleListener(handler, true));
			return this;
		}

		/**
		 * @inheritDoc
		 */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			priority = flipPriority(type, priority);
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		/*============================================================================*/
		/* Internal Functions                                                         */
		/*============================================================================*/

		internal function setCurrentState(state:String):void
		{
			if (_state == state)
				return;
			_state = state;
			dispatchEvent(new LifecycleEvent(LifecycleEvent.STATE_CHANGE));
		}

		internal function addReversedEventTypes(... types):void
		{
			for each (var type:String in types)
			{
				_reversedEventTypes[type] = true;
			}
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function configureTransitions():void
		{
			_initialize = new LifecycleTransition(LifecycleEvent.PRE_INITIALIZE, this)
				.fromStates(LifecycleState.UNINITIALIZED)
				.toStates(LifecycleState.INITIALIZING, LifecycleState.ACTIVE)
				.withEvents(LifecycleEvent.PRE_INITIALIZE, LifecycleEvent.INITIALIZE, LifecycleEvent.POST_INITIALIZE);

			_suspend = new LifecycleTransition(LifecycleEvent.PRE_SUSPEND, this)
				.fromStates(LifecycleState.ACTIVE)
				.toStates(LifecycleState.SUSPENDING, LifecycleState.SUSPENDED)
				.withEvents(LifecycleEvent.PRE_SUSPEND, LifecycleEvent.SUSPEND, LifecycleEvent.POST_SUSPEND)
				.inReverse();

			_resume = new LifecycleTransition(LifecycleEvent.PRE_RESUME, this)
				.fromStates(LifecycleState.SUSPENDED)
				.toStates(LifecycleState.RESUMING, LifecycleState.ACTIVE)
				.withEvents(LifecycleEvent.PRE_RESUME, LifecycleEvent.RESUME, LifecycleEvent.POST_RESUME);

			_destroy = new LifecycleTransition(LifecycleEvent.PRE_DESTROY, this)
				.fromStates(LifecycleState.SUSPENDED, LifecycleState.ACTIVE)
				.toStates(LifecycleState.DESTROYING, LifecycleState.DESTROYED)
				.withEvents(LifecycleEvent.PRE_DESTROY, LifecycleEvent.DESTROY, LifecycleEvent.POST_DESTROY)
				.inReverse();
		}

		private function flipPriority(type:String, priority:int):int
		{
			return (priority == 0 && _reversedEventTypes[type])
				? _reversePriority++
				: priority;
		}

		private function createLifecycleListener(handler:Function, once:Boolean = false):Function
		{
			// When and After handlers can not be asynchronous
			if (handler.length > 1)
			{
				throw new Error("When and After handlers must accept 0-1 arguments");
			}

			// A handler that accepts 1 argument is provided with the event type
			if (handler.length == 1)
			{
				return function(event:LifecycleEvent):void {
					once && IEventDispatcher(event.target)
						.removeEventListener(event.type, arguments.callee);
					handler(event.type);
				};
			}

			// Or, just call the handler
			return function(event:LifecycleEvent):void {
				once && IEventDispatcher(event.target)
					.removeEventListener(event.type, arguments.callee);
				handler();
			};
		}
	}
}
