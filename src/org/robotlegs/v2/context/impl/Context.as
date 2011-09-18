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
	import flash.system.ApplicationDomain;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import org.robotlegs.adapters.SwiftSuspendersInjector;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.v2.context.api.IContext;
	import org.robotlegs.v2.view.impl.ContextViewRegistry;

	public class Context implements IContext
	{

		/*============================================================================*/
		/* Protected Static Properties                                                */
		/*============================================================================*/

		protected static const logger:ILogger = getLogger(Context);


		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		protected var _applicationDomain:ApplicationDomain;

		public function get applicationDomain():ApplicationDomain
		{
			return _applicationDomain;
		}


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
		/* Public Functions                                                           */
		/*============================================================================*/

		public function destroy():void
		{
			// todo: cleanup
		}

		public function initialize():void
		{
			logger.info('initializing');
			_initialized && throwContextLockedError();
			_initialized = true;
			configureApplicationDomain();
			configureDispatcher();
			configureInjector();
			mapInjections();
			addToContextViewRegistry();
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/

		protected function addToContextViewRegistry():void
		{
			if (contextView)
				ContextViewRegistry.getSingleton().addContext(this);
		}

		protected function configureApplicationDomain():void
		{
			if (contextView && contextView.loaderInfo)
			{
				_applicationDomain = contextView.loaderInfo.applicationDomain;
			}
			else
			{
				_applicationDomain = ApplicationDomain.currentDomain;
			}
		}

		protected function configureDispatcher():void
		{
			_dispatcher ||= new EventDispatcher();
		}

		protected function configureInjector():void
		{
			_injector ||= parent ?
				parent.injector.createChild(_applicationDomain) :
				new SwiftSuspendersInjector();
		}

		protected function mapInjections():void
		{
			injector.mapValue(IContext, this);
			injector.mapValue(IInjector, injector);
			injector.mapValue(IEventDispatcher, dispatcher);
			injector.mapValue(DisplayObjectContainer, contextView);
		}

		protected function throwContextLockedError():void
		{
			const message:String = 'This context has already been initialized and is now locked';
			logger.fatal(message);
			throw new IllegalOperationError(message);
		}
	}
}
