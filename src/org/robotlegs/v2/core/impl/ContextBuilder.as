//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.core.impl
{
	import flash.display.DisplayObjectContainer;
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import org.robotlegs.v2.core.api.ContextBuilderEvent;
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.api.IContextBuilder;
	import org.robotlegs.v2.core.api.IContextBuilderBundle;
	import org.robotlegs.v2.core.api.IContextExtension;
	import org.robotlegs.v2.core.api.IContextProcessor;
	import org.swiftsuspenders.Injector;

	[Event(name="contextBuildComplete", type="org.robotlegs.v2.core.api.ContextBuilderEvent")]
	public class ContextBuilder extends EventDispatcher implements IContextBuilder
	{

		/*============================================================================*/
		/* Protected Static Properties                                                */
		/*============================================================================*/

		protected static var counter:int;


		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/

		protected const _id:String = 'ContextBuilder' + counter++;

		protected var buildLocked:Boolean;

		protected const configClasses:Vector.<Class> = new Vector.<Class>;

		protected const context:IContext = new Context();

		protected const logger:ILogger = getLogger(_id);

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
			logger.info('starting build');
			buildLocked && throwBuildLockedError();
			buildLocked = true;
			runProcessors();
			return context;
		}

		override public function toString():String
		{
			return _id;
		}

		public function withBundle(bundle:IContextBuilderBundle):IContextBuilder
		{
			logger.info('installing bundle: {0}', [bundle]);
			buildLocked && throwBuildLockedError();
			bundle.install(this);
			return this;
		}

		public function withConfig(configClass:Class):IContextBuilder
		{
			logger.info('adding config: {0}', [configClass]);
			buildLocked && throwBuildLockedError();
			configClasses.push(configClass);
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

		public function withExtension(extension:IContextExtension):IContextBuilder
		{
			logger.info('adding extension: {0}', [extension]);
			buildLocked && throwBuildLockedError();
			context.installExtension(extension);
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

		public function withProcessor(processor:IContextProcessor):IContextBuilder
		{
			logger.info('adding processor: {0}', [processor]);
			buildLocked && throwBuildLockedError();
			processors.push(processor);
			return this;
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/



		protected function createConfigs():void
		{
			logger.info('creating configs');
			configClasses.forEach(function(configClass:Class, ... rest):void
			{
				context.injector.getInstance(configClass);
			}, this);
		}

		protected function finishBuild():void
		{
			context.initialize();
			createConfigs();
			dispatchEvent(new ContextBuilderEvent(ContextBuilderEvent.CONTEXT_BUILD_COMPLETE, this, context));
		}


		protected function processorCallback(error:Object = null):void
		{
			if (error)
			{
				throw new Error(error);
			}
			else if (processors.length > 0)
			{
				const processor:IContextProcessor = processors.shift();
				logger.info('executing processor: {0}', [processor]);
				processor.process(context, processorCallback);
			}
			else
			{
				finishBuild();
			}
		}

		protected function runProcessors():void
		{
			logger.info('running processors');
			processorCallback();
		}

		protected function throwBuildLockedError():void
		{
			const message:String = 'The build has started and is now locked';
			logger.fatal(message);
			throw new IllegalOperationError(message);
		}
	}
}

