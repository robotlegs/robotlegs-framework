//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.framework.api
{
	import flash.events.IEventDispatcher;

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
	 * The Robotlegs context contract
	 */
	public interface IContext extends IEventDispatcher
	{
		/**
		 * The context dependency injector
		 */
		function get injector():IInjector;

		/**
		 * The current log level
		 */
		function get logLevel():uint;

		/**
		 * Sets the current log level
		 * @param value The log level. Use a constant from LogLevel
		 */
		function set logLevel(value:uint):void;

		/**
		 * The current lifecycle state
		 */
		function get state():String;

		/**
		 * Is this context uninitialized?
		 */
		function get uninitialized():Boolean;

		/**
		 * Is this context initialized?
		 */
		function get initialized():Boolean;

		/**
		 * Is this context active?
		 */
		function get active():Boolean;

		/**
		 * Is this context suspended?
		 */
		function get suspended():Boolean;

		/**
		 * Has this context been destroyed?
		 */
		function get destroyed():Boolean;

		/**
		 * Installs custom extensions or bundles into the context
		 * @param extensions Objects or classes implementing IExtension or IBundle
		 * @return this
		 */
		function install(... extensions):IContext;

		/**
		 * Configures the context with custom configurations
		 * @param configs Configuration objects or classes of any type
		 * @return this
		 */
		function configure(... configs):IContext;

		/**
		 * Adds an uninitialized context as a child
		 *
		 * <p>This sets up an injection chain.</p>
		 *
		 * @param child The context to add as a child
		 * @return this
		 */
		function addChild(child:IContext):IContext;

		/**
		 * Removes a child context from this context
		 * @param child The child context to remove
		 * @return this
		 */
		function removeChild(child:IContext):IContext;

		/**
		 * Adds a custom configuration handler
		 * @param matcher Pattern to match configurations
		 * @param handler Handler to process matching configurations
		 * @return this
		 */
		function addConfigHandler(matcher:IMatcher, handler:Function):IContext;

		/**
		 * Retrieves a logger for a given source
		 * @param source Logging source
		 * @return Logger
		 */
		function getLogger(source:Object):ILogger;

		/**
		 * Adds a custom log target
		 * @param target Log target
		 * @return this
		 */
		function addLogTarget(target:ILogTarget):IContext;

		/**
		 * Pins instances in memory
		 * @param instances Instances to pin
		 * @return this
		 */
		function detain(... instances):IContext;

		/**
		 * Unpins instances from memory
		 * @param instances Instances to unpin
		 * @return this
		 */
		function release(... instances):IContext;

		/**
		 * Initializes this context
		 * @param callback Initialization callback
		 */
		function initialize(callback:Function = null):void;

		/**
		 * Suspends this context
		 * @param callback Suspension callback
		 */
		function suspend(callback:Function = null):void;

		/**
		 * Resumes a suspended context
		 * @param callback Resumption callback
		 */
		function resume(callback:Function = null):void;

		/**
		 * Destroys an active context
		 * @param callback Destruction callback
		 */
		function destroy(callback:Function = null):void;

		/**
		 * A handler to run before the context is initialized
		 *
		 * <p>The handler can be asynchronous. See: readme-async</p>
		 *
		 * @param handler Pre-initialize handler
		 * @return this
		 */
		function beforeInitializing(handler:Function):IContext;

		/**
		 * A handler to run during initialization
		 *
		 * <p>Note: The handler must be synchronous.</p>
		 * @param handler Initialization handler
		 * @return this
		 */
		function whenInitializing(handler:Function):IContext;

		/**
		 * A handler to run after initialization
		 *
		 * <p>Note: The handler must be synchronous.</p>
		 * @param handler Post-initialize handler
		 * @return this
		 */
		function afterInitializing(handler:Function):IContext;

		/**
		 * A handler to run before the target object is suspended
		 *
		 * <p>The handler can be asynchronous. See: readme-async</p>
		 *
		 * @param handler Pre-suspend handler
		 * @return this
		 */
		function beforeSuspending(handler:Function):IContext;

		/**
		 * A handler to run during suspension
		 *
		 * <p>Note: The handler must be synchronous.</p>
		 * @param handler Suspension handler
		 * @return this
		 */
		function whenSuspending(handler:Function):IContext;

		/**
		 * A handler to run after suspension
		 *
		 * <p>Note: The handler must be synchronous.</p>
		 * @param handler Post-suspend handler
		 * @return this
		 */
		function afterSuspending(handler:Function):IContext;

		/**
		 * A handler to run before the context is resumed
		 *
		 * <p>The handler can be asynchronous. See: readme-async</p>
		 *
		 * @param handler Pre-resume handler
		 * @return this
		 */
		function beforeResuming(handler:Function):IContext;

		/**
		 * A handler to run during resumption
		 *
		 * <p>Note: The handler must be synchronous.</p>
		 * @param handler Resumption handler
		 * @return this
		 */
		function whenResuming(handler:Function):IContext;

		/**
		 * A handler to run after resumption
		 *
		 * <p>Note: The handler must be synchronous.</p>
		 * @param handler Post-resume handler
		 * @return Self
		 */
		function afterResuming(handler:Function):IContext;

		/**
		 * A handler to run before the context is destroyed
		 *
		 * <p>The handler can be asynchronous. See: readme-async</p>
		 *
		 * @param handler Pre-destroy handler
		 * @return this
		 */
		function beforeDestroying(handler:Function):IContext;

		/**
		 * A handler to run during destruction
		 *
		 * <p>Note: The handler must be synchronous.</p>
		 * @param handler Destruction handler
		 * @return this
		 */
		function whenDestroying(handler:Function):IContext;

		/**
		 * A handler to run after destruction
		 *
		 * <p>Note: The handler must be synchronous.</p>
		 * @param handler Post-destroy handler
		 * @return this
		 */
		function afterDestroying(handler:Function):IContext;
	}
}
