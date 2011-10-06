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
	import flash.utils.getTimer;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.v2.context.api.ContextBuilderEvent;
	import org.robotlegs.v2.context.api.IContext;
	import org.robotlegs.v2.context.api.IContextBuilder;
	import org.robotlegs.v2.context.api.IContextBuilderBundle;
	import org.robotlegs.v2.context.api.IContextProcessor;
	import org.robotlegs.v2.context.api.IUtilityInstaller;

	[Event(name="contextBuildComplete", type="org.robotlegs.v2.context.api.ContextBuilderEvent")]
	public class ContextBuilder extends EventDispatcher implements IContextBuilder
	{

		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/

		protected const _id:String = 'ContextBuilder' + getTimer();

		protected var buildLocked:Boolean;

		protected const configClasses:Vector.<Class> = new Vector.<Class>;

		protected const context:IContext = new Context();

		protected const logger:ILogger = getLogger(_id);

		protected const processors:Vector.<IContextProcessor> = new Vector.<IContextProcessor>;

		protected const utilityInstallers:Vector.<IUtilityInstaller> = new Vector.<IUtilityInstaller>;

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

		public function installProcessor(processor:IContextProcessor):IContextBuilder
		{
			logger.info('adding processor: {0}', [processor]);
			buildLocked && throwBuildLockedError();
			processors.push(processor);
			return this;
		}

		public function build():IContext
		{
			logger.info('starting build');
			buildLocked && throwBuildLockedError();
			buildLocked = true;
			runProcessors();
			return context;
		}

		public function installBundle(bundle:IContextBuilderBundle):IContextBuilder
		{
			logger.info('installing bundle: {0}', [bundle]);
			buildLocked && throwBuildLockedError();
			bundle.install(this);
			return this;
		}

		public function installUtility(installer:IUtilityInstaller):IContextBuilder
		{
			logger.info('adding utility installer: {0}', [installer]);
			buildLocked && throwBuildLockedError();
			utilityInstallers.push(installer);
			return this;
		}

		override public function toString():String
		{
			return _id;
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

		protected function createConfigs():void
		{
			logger.info('creating configs');
			configClasses.forEach(function(configClass:Class, ... rest):void
			{
				context.injector.instantiate(configClass);
			}, this);
		}

		protected function finishBuild():void
		{
			context.initialize();
			installUtilities();
			startUtilities();
			createConfigs();
			dispatchEvent(new ContextBuilderEvent(ContextBuilderEvent.CONTEXT_BUILD_COMPLETE, this, context));
		}

		protected function installUtilities():void
		{
			logger.info('installing utilities');
			utilityInstallers.forEach(function(installer:IUtilityInstaller, ... rest):void
			{
				installer.install(context);
			}, this);
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

		protected function startUtilities():void
		{
			logger.info('starting utilities');
			utilityInstallers.forEach(function(installer:IUtilityInstaller, ... rest):void
			{
				installer.start();
			}, this);
		}

		protected function throwBuildLockedError():void
		{
			const message:String = 'The build has started and is now locked';
			logger.fatal(message);
			throw new IllegalOperationError(message);
		}
	}
}

