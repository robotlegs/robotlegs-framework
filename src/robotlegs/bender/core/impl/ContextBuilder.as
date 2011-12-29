//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.core.impl
{
	import flash.display.DisplayObjectContainer;
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import robotlegs.bender.core.api.ContextBuilderEvent;
	import robotlegs.bender.core.api.IContext;
	import robotlegs.bender.core.api.IContextBuilder;
	import robotlegs.bender.core.api.IContextBuilderBundle;
	import robotlegs.bender.core.api.IContextLogTarget;
	import robotlegs.bender.core.api.IContextLogger;
	import org.swiftsuspenders.Injector;

	[Event(name="contextBuildComplete", type="robotlegs.bender.core.api.ContextBuilderEvent")]
	public class ContextBuilder extends EventDispatcher implements IContextBuilder
	{

		private static var counter:int;

		protected const context:IContext = new Context();

		private const _id:String = 'ContextBuilder' + counter++;

		private const logger:IContextLogger = context.logger;

		private var buildLocked:Boolean;

		public function ContextBuilder()
		{
			// -- hello, welcome to Robotlegs -- //
		}

		public function build():IContext
		{
			logger.info(this, 'starting build');
			buildLocked && throwBuildLockedError();
			buildLocked = true;
			context.initialize(finishBuild);
			return context;
		}

		override public function toString():String
		{
			return _id;
		}

		public function withBundle(bundleClass:Class):IContextBuilder
		{
			logger.info(this, 'installing bundle: {0}', [bundleClass]);
			buildLocked && throwBuildLockedError();
			const bundle:IContextBuilderBundle = new bundleClass();
			bundle.install(this);
			return this;
		}

		public function withConfig(configClass:Class):IContextBuilder
		{
			logger.info(this, 'adding config: {0}', [configClass]);
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
			logger.info(this, 'adding extension: {0}', [extensionClass]);
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

		public function withLogTarget(target:IContextLogTarget):IContextBuilder
		{
			logger.addTarget(target);
			logger.info(this, 'setting log target: {0}', [target]);
			return this;
		}

		protected function finishBuild():void
		{
			logger.info(this, 'Build complete.');
			dispatchEvent(new ContextBuilderEvent(ContextBuilderEvent.CONTEXT_BUILD_COMPLETE, this, context));
		}

		protected function throwBuildLockedError():void
		{
			const message:String = 'The build has started and is now locked.';
			logger.fatal(this, message);
			throw new IllegalOperationError(message);
		}
	}
}

