//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.context.restricted
{
	import flash.display.DisplayObjectContainer;
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import org.robotlegs.v2.context.api.ContextBuilderEvent;
	import org.robotlegs.v2.context.api.IContext;
	import org.robotlegs.v2.context.api.IContextBuilder;
	import org.robotlegs.v2.context.api.IContextBuilderConfig;
	import org.swiftsuspenders.v2.core.FactoryMap;
	import org.swiftsuspenders.v2.core.FactoryMapper;
	import org.swiftsuspenders.v2.core.FactoryRequest;
	import org.swiftsuspenders.v2.core.Injector;
	import org.swiftsuspenders.v2.dsl.IFactoryMap;
	import org.swiftsuspenders.v2.dsl.IFactoryMapping;
	import org.swiftsuspenders.v2.dsl.IInjector;

	[Event(name="contextBuildComplete", type="org.robotlegs.v2.context.api.ContextBuilderEvent")]
	public class ContextBuilder extends EventDispatcher implements IContextBuilder
	{

		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/

		protected var buildLocked:Boolean;

		protected var context:IContext;

		protected var _contextView:DisplayObjectContainer;

		protected function get contextView():DisplayObjectContainer
		{
			return _contextView;
		}

		protected var _dispatcher:IEventDispatcher;

		protected function get dispatcher():IEventDispatcher
		{
			return _dispatcher ||= new EventDispatcher();
		}

		protected var factoryMap:IFactoryMap = new FactoryMap();

		protected var _injector:IInjector;

		protected function get injector():IInjector
		{
			return _injector ||= new Injector();
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function ContextBuilder()
		{
			// -- hello, welcome to Robotlegs -- //
		}


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function build():IContext
		{
			buildLocked && throwBuildLockedError();
			buildLocked = true;

			configureInjections();
			configureUtilities();
			createUtilities();

			dispatchEvent(new ContextBuilderEvent(ContextBuilderEvent.CONTEXT_BUILD_COMPLETE, this));
			return context;
		}

		public function installConfig(config:IContextBuilderConfig):IContextBuilder
		{
			buildLocked && throwBuildLockedError();
			config.configure(this);
			return this;
		}

		public function installUtility(type:Class, implementation:Class = null, named:String = ''):IContextBuilder
		{
			buildLocked && throwBuildLockedError();
			const request:FactoryRequest = new FactoryRequest(type, named);
			const mapper:FactoryMapper = new FactoryMapper(factoryMap, request);
			mapper.asSingleton(implementation);
			return this;
		}

		public function withContextView(container:DisplayObjectContainer):IContextBuilder
		{
			buildLocked && throwBuildLockedError();
			_contextView && throwContextViewLockedError();
			_contextView = container;
			return this;
		}

		public function withDispatcher(dispatcher:IEventDispatcher):IContextBuilder
		{
			buildLocked && throwBuildLockedError();
			_dispatcher && throwDispatcherLockedError();
			_dispatcher = dispatcher;
			return this;
		}

		public function withInjector(injector:IInjector):IContextBuilder
		{
			buildLocked && throwBuildLockedError();
			_injector && throwInjectorLockedError();
			_injector = injector;
			return this;
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/

		protected function configureInjections():void
		{
			context = new Context(injector);
			injector.map(IInjector).asSingleton(Injector);
			injector.map(IEventDispatcher).toInstance(dispatcher);
			injector.map(IContextBuilder).toInstance(this);
			injector.map(IContext).toInstance(context);
			contextView && injector.map(DisplayObjectContainer).toInstance(contextView);
		}

		protected function configureUtilities():void
		{
			factoryMap.mappings.forEach(function(mapping:IFactoryMapping, ... rest):void
			{
				injector.map(mapping.request.type, mapping.request.name)
					.toFactory(mapping.factory);
			}, this);
		}

		protected function createUtilities():void
		{
			factoryMap.mappings.forEach(function(mapping:IFactoryMapping, ... rest):void
			{
				injector.getInstance(mapping.request.type, mapping.request.name);
			}, this);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function throwBuildLockedError():void
		{
			throw new IllegalOperationError("ContextBuilder: build has started and is now locked");
		}

		private function throwContextViewLockedError():void
		{
			throw new IllegalOperationError("ContextBuilder: contextView has been set and is now locked");
		}

		private function throwDispatcherLockedError():void
		{
			throw new IllegalOperationError("ContextBuilder: dispatcher has been set and is now locked");
		}

		private function throwInjectorLockedError():void
		{
			throw new IllegalOperationError("ContextBuilder: injector has been set and is now locked");
		}
	}
}
