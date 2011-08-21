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
	import org.robotlegs.core.IInjector;
	import org.robotlegs.v2.context.api.ContextBuilderEvent;
	import org.robotlegs.v2.context.api.IContext;
	import org.robotlegs.v2.context.api.IContextBuilder;
	import org.robotlegs.v2.context.api.IContextBuilderConfig;
	import org.robotlegs.v2.context.api.IContextProcessor;

	[Event(name="contextBuildComplete", type="org.robotlegs.v2.context.api.ContextBuilderEvent")]
	public class ContextBuilder extends EventDispatcher implements IContextBuilder
	{

		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/

		protected var buildLocked:Boolean;

		protected const context:IContext = new Context();

		protected const processors:Vector.<IContextProcessor> = new Vector.<IContextProcessor>;

		protected const utilityConfigs:Vector.<UtilityConfig> = new Vector.<UtilityConfig>;

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
			const config:UtilityConfig = new UtilityConfig();
			config.type = type;
			config.implementation = implementation || type;
			config.name = named;
			utilityConfigs.push(config);
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
			utilityConfigs.forEach(function(config:UtilityConfig, ... rest):void
			{
				context.injector.mapSingletonOf(config.type, config.implementation, config.name);
			}, this);
		}

		protected function createUtilities():void
		{
			utilityConfigs.forEach(function(config:UtilityConfig, ... rest):void
			{
				context.injector.getInstance(config.type, config.name);
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

class UtilityConfig
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	public var implementation:Class;

	public var name:String;

	public var type:Class;
}
