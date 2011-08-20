//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.context.impl
{
	import flash.display.DisplayObjectContainer;
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import org.robotlegs.v2.context.api.IContext;
	import org.robotlegs.v2.view.impl.ContextViewRegistry;
	import org.swiftsuspenders.v2.core.Injector;
	import org.swiftsuspenders.v2.dsl.IInjector;

	public class Context implements IContext
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		protected var _contextView:DisplayObjectContainer;

		public function get contextView():DisplayObjectContainer
		{
			return _contextView;
		}

		public function set contextView(value:DisplayObjectContainer):void
		{
			_initialized && throwContextLockedError();
			_contextView = value;
		}


		protected var _dispatcher:IEventDispatcher;

		public function get dispatcher():IEventDispatcher
		{
			return _dispatcher;
		}

		public function set dispatcher(value:IEventDispatcher):void
		{
			_initialized && throwContextLockedError();
			_dispatcher = value;
		}

		protected var _initialized:Boolean;

		public function get initialized():Boolean
		{
			return _initialized;
		}


		protected var _injector:IInjector;

		public function get injector():IInjector
		{
			return _injector;
		}

		public function set injector(value:IInjector):void
		{
			_initialized && throwContextLockedError();
			_injector = value;
		}


		protected var _parent:IContext;

		public function get parent():IContext
		{
			return _parent;
		}

		public function set parent(value:IContext):void
		{
			_initialized && throwContextLockedError();
			_parent = value;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function Context()
		{
		}


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function initialize():void
		{
			_initialized && throwContextLockedError();
			_initialized = true;

			// todo: set parent injector based on context.parent
			_injector ||= new Injector();
			_dispatcher ||= new EventDispatcher();

			injector.map(IContext).toInstance(this);
			injector.map(IInjector).toInstance(injector);
			injector.map(IEventDispatcher).toInstance(dispatcher);
			injector.map(DisplayObjectContainer).toInstance(contextView);

			if (contextView)
				ContextViewRegistry.getSingleton().addContext(this);
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/

		protected function throwContextLockedError():void
		{
			throw new IllegalOperationError("Context: the context has already been initialized and is now locked.");
		}
	}
}
