//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.core.impl
{
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;
	import robotlegs.bender.core.api.IContext;
	import robotlegs.bender.core.api.IContextConfig;

	public class ConfigManager
	{
		private const configClasses:Vector.<Class> = new Vector.<Class>;

		private const configByClass:Dictionary = new Dictionary();

		private var context:IContext;

		private var initialized:Boolean;

		private var destroyed:Boolean;

		public function ConfigManager(context:IContext)
		{
			this.context = context;
		}

		public function addConfig(configClass:Class):void
		{
			initialized && throwInitializedError();

			if (hasConfig(configClass))
				return;

			configClasses.push(configClass);
		}

		public function hasConfig(configClass:Class):Boolean
		{
			return configClasses.indexOf(configClass) > -1;
		}

		public function removeConfig(configClass:Class):void
		{
			initialized && throwInitializedError();

			if (!hasConfig(configClass))
				return;

			configClasses.splice(configClasses.indexOf(configClass), 1);
			delete configByClass[configClass];
		}

		public function initialize():void
		{
			initialized && throwInitializedError();
			initialized = true;
			initializeConfigs();
		}

		public function destroy():void
		{
			destroyed && throwDestroyedError();
			destroyed = true;
			destroyConfigs();
		}

		private function initializeConfigs():void
		{
			configClasses.forEach(function(configClass:Class, ... rest):void
			{
				const config:IContextConfig = context.injector.getInstance(configClass);
				configByClass[configClass] = config;
				config.configure(context);
			}, this);
		}

		private function destroyConfigs():void
		{
			// Note: destroy in reverse order
			var configClass:Class;
			while (configClass = configClasses.pop())
			{
				const config:IContextConfig = configByClass[configClass];
				delete configByClass[configClass];
					// todo: config teardown?
			}
		}

		private function throwInitializedError():void
		{
			const message:String = 'This manager has been initialized and is now locked.';
			context.logger.fatal(ConfigManager, message);
			throw new IllegalOperationError(message);
		}

		private function throwDestroyedError():void
		{
			const message:String = 'This manager has been destroyed and is now dead.';
			context.logger.fatal(ConfigManager, message);
			throw new IllegalOperationError(message);
		}
	}
}
