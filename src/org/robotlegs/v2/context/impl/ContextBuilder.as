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
	import org.robotlegs.v2.context.api.ContextBuilderEvent;
	import org.robotlegs.v2.context.api.IContext;
	import org.robotlegs.v2.context.api.IContextBuilder;
	import org.robotlegs.v2.context.api.IContextBuilderConfig;
	import org.robotlegs.v2.context.api.IContextProcessor;
	import org.swiftsuspenders.v2.core.FactoryMap;
	import org.swiftsuspenders.v2.core.FactoryMapper;
	import org.swiftsuspenders.v2.core.FactoryRequest;
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

		protected const context:IContext = new Context();

		protected const factoryMap:IFactoryMap = new FactoryMap();

		protected const processors:Vector.<IContextProcessor> = new Vector.<IContextProcessor>;

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
			runProcessors();
			return context;
		}

		public function installConfig(config:IContextBuilderConfig):IContextBuilder
		{
			buildLocked && throwBuildLockedError();
			config.configure(this);
			return this;
		}

		public function installProcessor(processor:IContextProcessor):IContextBuilder
		{
			buildLocked && throwBuildLockedError();
			processors.push(processor);
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

		public function withContextView(value:DisplayObjectContainer):IContextBuilder
		{
			context.contextView = value;
			return this;
		}

		public function withDispatcher(value:IEventDispatcher):IContextBuilder
		{
			context.dispatcher = value;
			return this;
		}

		public function withInjector(value:IInjector):IContextBuilder
		{
			context.injector = value;
			return this;
		}

		public function withParent(value:IContext):IContextBuilder
		{
			context.parent = value;
			return this;
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/

		protected function configureUtilities():void
		{
			factoryMap.mappings.forEach(function(mapping:IFactoryMapping, ... rest):void
			{
				context.injector.map(mapping.request.type, mapping.request.name)
					.toFactory(mapping.factory);
			}, this);
		}

		protected function createUtilities():void
		{
			factoryMap.mappings.forEach(function(mapping:IFactoryMapping, ... rest):void
			{
				context.injector.getInstance(mapping.request.type, mapping.request.name);
			}, this);
		}

		protected function finish(error:Object = null):void
		{
			if (error)
				throw new Error(error);

			context.initialize();
			configureUtilities();
			createUtilities();

			dispatchEvent(new ContextBuilderEvent(ContextBuilderEvent.CONTEXT_BUILD_COMPLETE, this));
		}

		protected function processorCallback(error:Object = null):void
		{
			if (error || processors.length == 0)
			{
				finish(error);
			}
			else
			{
				processors.shift().process(context, processorCallback);
			}
		}

		protected function runProcessors():void
		{
			processorCallback();
		}

		protected function throwBuildLockedError():void
		{
			throw new IllegalOperationError("ContextBuilder: build has started and is now locked.");
		}
	}
}
