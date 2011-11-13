//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.core.impl
{
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.api.IContextExtension;

	public class ExtensionManager
	{
		private const extensionClasses:Vector.<Class> = new Vector.<Class>;

		private const extensionByClass:Dictionary = new Dictionary();

		private var context:IContext;

		private var initialized:Boolean;

		private var destroyed:Boolean;

		public function ExtensionManager(context:IContext)
		{
			this.context = context;
		}

		public function addExtension(extensionClass:Class):void
		{
			destroyed && throwDestroyedError();
			if (hasExtension(extensionClass))
				return;

			extensionClasses.push(extensionClass);

			if (initialized)
			{
				const extension:IContextExtension = createExtension(extensionClass);
				extension.install(context);
				extension.initialize();
			}
		}

		public function hasExtension(extensionClass:Class):Boolean
		{
			return extensionClasses.indexOf(extensionClass) > -1;
		}

		public function removeExtension(extensionClass:Class):void
		{
			destroyed && throwDestroyedError();
			if (!hasExtension(extensionClass))
				return;

			extensionClasses.splice(extensionClasses.indexOf(extensionClass), 1);

			const extension:IContextExtension = extensionByClass[extensionClass];
			delete extensionByClass[extensionClass];
			extension && extension.uninstall();
		}

		public function initialize():void
		{
			initialized && throwInitializedError();
			initialized = true;
			installExtensions();
			initializeExtensions();
		}

		public function destroy():void
		{
			destroyed && throwDestroyedError();
			destroyed = true;
			uninstallExtensions();
		}

		private function createExtension(extensionClass:Class):IContextExtension
		{
			const extension:IContextExtension = new extensionClass();
			extensionByClass[extensionClass] = extension;
			return extension;
		}

		private function installExtensions():void
		{
			extensionClasses.forEach(function(extensionClass:Class, ... rest):void
			{
				const extension:IContextExtension = createExtension(extensionClass);
				extension.install(context);
			}, this);
		}

		private function initializeExtensions():void
		{
			extensionClasses.forEach(function(extensionClass:Class, ... rest):void
			{
				const extension:IContextExtension = extensionByClass[extensionClass];
				extension.initialize();
			}, this);
		}

		private function uninstallExtensions():void
		{
			// Note: uninstall in reverse order
			var extensionClass:Class;
			while (extensionClass = extensionClasses.pop())
			{
				const extension:IContextExtension = extensionByClass[extensionClass];
				delete extensionByClass[extensionClass];
				extension.uninstall();
			}
		}

		private function throwInitializedError():void
		{
			const message:String = 'This manager has been initialized and is now locked.';
			context.logger.fatal(this, message);
			throw new IllegalOperationError(message);
		}

		private function throwDestroyedError():void
		{
			const message:String = 'This manager has been destroyed and is now dead.';
			context.logger.fatal(this, message);
			throw new IllegalOperationError(message);
		}
	}
}
