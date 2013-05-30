//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import robotlegs.bender.framework.api.ILifecycle;
	import robotlegs.bender.framework.api.LifecycleError;
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
	public class Lifecycle implements ILifecycle
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

		private var _dispatcher:IEventDispatcher;

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
			_dispatcher = target as IEventDispatcher || new EventDispatcher(this);
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
			uninitialized || reportError(LifecycleError.LATE_HANDLER_ERROR_MESSAGE);
			_initialize.addBeforeHandler(handler);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function whenInitializing(handler:Function):ILifecycle
		{
			initialized && reportError(LifecycleError.LATE_HANDLER_ERROR_MESSAGE);
			addEventListener(LifecycleEvent.INITIALIZE, createSyncLifecycleListener(handler, true));
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function afterInitializing(handler:Function):ILifecycle
		{
			initialized && reportError(LifecycleError.LATE_HANDLER_ERROR_MESSAGE);
			addEventListener(LifecycleEvent.POST_INITIALIZE, createSyncLifecycleListener(handler, true));
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
		public function whenSuspending(handler:Function):ILifecycle
		{
			addEventListener(LifecycleEvent.SUSPEND, createSyncLifecycleListener(handler));
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function afterSuspending(handler:Function):ILifecycle
		{
			addEventListener(LifecycleEvent.POST_SUSPEND, createSyncLifecycleListener(handler));
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
		public function whenResuming(handler:Function):ILifecycle
		{
			addEventListener(LifecycleEvent.RESUME, createSyncLifecycleListener(handler));
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function afterResuming(handler:Function):ILifecycle
		{
			addEventListener(LifecycleEvent.POST_RESUME, createSyncLifecycleListener(handler));
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
		public function whenDestroying(handler:Function):ILifecycle
		{
			addEventListener(LifecycleEvent.DESTROY, createSyncLifecycleListener(handler, true));
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function afterDestroying(handler:Function):ILifecycle
		{
			addEventListener(LifecycleEvent.POST_DESTROY, createSyncLifecycleListener(handler, true));
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			priority = flipPriority(type, priority);
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		/**
		 * @inheritDoc
		 */
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			_dispatcher.removeEventListener(type, listener, useCapture);
		}

		/**
		 * @inheritDoc
		 */
		public function dispatchEvent(event:Event):Boolean
		{
			return _dispatcher.dispatchEvent(event);
		}

		/**
		 * @inheritDoc
		 */
		public function hasEventListener(type:String):Boolean
		{
			return _dispatcher.hasEventListener(type);
		}

		/**
		 * @inheritDoc
		 */
		public function willTrigger(type:String):Boolean
		{
			return _dispatcher.willTrigger(type);
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

		private function createSyncLifecycleListener(handler:Function, once:Boolean = false):Function
		{
			// When and After handlers can not be asynchronous
			if (handler.length > 1)
			{
				throw new LifecycleError(LifecycleError.SYNC_HANDLER_ARG_MISMATCH);
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

		private function reportError(message:String):void
		{
			const error:LifecycleError = new LifecycleError(message);
			if (hasEventListener(LifecycleEvent.ERROR))
			{
				const event:LifecycleEvent = new LifecycleEvent(LifecycleEvent.ERROR, error);
				dispatchEvent(event);
			}
			else
			{
				throw error;
			}
		}
	}
}
