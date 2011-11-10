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
	import org.robotlegs.v2.core.api.ContextBuilderEvent;
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.api.IContextBuilder;
	import org.robotlegs.v2.core.api.IContextBuilderBundle;
	import org.robotlegs.v2.core.api.IContextPreProcessor;
	import org.robotlegs.v2.core.api.ILogTarget;
	import org.robotlegs.v2.core.api.ILogger;
	import org.swiftsuspenders.Injector;

	[Event(name="contextBuildComplete", type="org.robotlegs.v2.core.api.ContextBuilderEvent")]
	public class ContextBuilder extends EventDispatcher implements IContextBuilder
	{

		protected static var counter:int;

		protected const _id:String = 'ContextBuilder' + counter++;

		protected const context:IContext = new Context();

		protected const logger:ILogger = new Logger(_id);

		protected const preProcessorClasses:Vector.<Class> = new Vector.<Class>;

		protected var buildLocked:Boolean;

		public function ContextBuilder()
		{
			// -- hello, welcome to Robotlegs -- //
		}

		public function build():IContext
		{
			logger.info('starting build');
			buildLocked && throwBuildLockedError();
			buildLocked = true;
			runPreProcessors();
			return context;
		}

		override public function toString():String
		{
			return _id;
		}

		public function withBundle(bundleClass:Class):IContextBuilder
		{
			logger.info('installing bundle: {0}', [bundleClass]);
			buildLocked && throwBuildLockedError();
			const bundle:IContextBuilderBundle = new bundleClass();
			bundle.install(this);
			return this;
		}

		public function withConfig(configClass:Class):IContextBuilder
		{
			logger.info('adding config: {0}', [configClass]);
			buildLocked && throwBuildLockedError();
			context.withConfig(configClass);
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

		public function withExtension(extensionClass:Class):IContextBuilder
		{
			logger.info('adding extension: {0}', [extensionClass]);
			buildLocked && throwBuildLockedError();
			context.installExtension(extensionClass);
			return this;
		}

		public function withInjector(value:Injector):IContextBuilder
		{
			context.injector = value;
			return this;
		}

		public function withParent(value:IContext):IContextBuilder
		{
			context.parent = value;
			return this;
		}

		public function withPreProcessor(preProcessorClass:Class):IContextBuilder
		{
			logger.info('adding processor: {0}', [preProcessorClass]);
			buildLocked && throwBuildLockedError();
			if (preProcessorClasses.indexOf(preProcessorClass) == -1)
				preProcessorClasses.push(preProcessorClass);
			return this;
		}

		public function withLogTarget(target:ILogTarget):IContextBuilder
		{
			logger.target = target;
			logger.info('setting log target: {0}', [target]);
			context.logger.target = target;
			return this;
		}

		protected function finishBuild():void
		{
			context.initialize();
			dispatchEvent(new ContextBuilderEvent(ContextBuilderEvent.CONTEXT_BUILD_COMPLETE, this, context));
		}

		protected function preProcessorCallback(error:Object = null):void
		{
			if (error)
			{
				throw new Error(error);
			}
			else if (preProcessorClasses.length > 0)
			{
				const preProcessorClass:Class = preProcessorClasses.shift();
				logger.info('executing processor: {0}', [preProcessorClass]);
				const preProcessor:IContextPreProcessor = new preProcessorClass();
				preProcessor.preProcess(context, preProcessorCallback);
			}
			else
			{
				finishBuild();
			}
		}

		protected function runPreProcessors():void
		{
			logger.info('running context pre-processors');
			preProcessorCallback();
		}

		protected function throwBuildLockedError():void
		{
			const message:String = 'The build has started and is now locked';
			logger.fatal(message);
			throw new IllegalOperationError(message);
		}
	}
}

