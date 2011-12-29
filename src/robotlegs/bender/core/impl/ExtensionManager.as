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
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	import robotlegs.bender.core.api.IContext;
	import robotlegs.bender.core.api.IContextExtension;
	import robotlegs.bender.core.api.IContextLogger;
	import robotlegs.bender.core.api.IContextPreProcessor;

	public class ExtensionManager
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const extensionClasses:Vector.<Class> = new Vector.<Class>;

		private const extensionByClass:Dictionary = new Dictionary();

		private const preProcessorClasses:Vector.<Class> = new Vector.<Class>;

		private var context:IContext;

		private var logger:IContextLogger;

		private var initializing:Boolean;

		private var initialized:Boolean;

		private var destroyed:Boolean;

		private var completeCallback:Function;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function ExtensionManager(context:IContext)
		{
			this.context = context;
			logger = context.logger;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function addExtension(extensionClass:Class):void
		{
			destroyed && throwDestroyedError();
			if (hasExtension(extensionClass))
				return;

			logger.info(this, 'Adding extension: ', [extensionClass]);
			extensionClasses.push(extensionClass);

			if (initialized)
			{
				const extension:IContextExtension = createExtension(extensionClass);
				extension.install(context);
				extension.initialize();
				if (extension is IContextPreProcessor)
				{
					logger.warn(this, 'Context pre processors added after initialization will not be run.');
				}
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

			logger.info(this, 'Removing extension: ', [extensionClass]);
			extensionClasses.splice(extensionClasses.indexOf(extensionClass), 1);

			const extension:IContextExtension = extensionByClass[extensionClass];
			delete extensionByClass[extensionClass];
			extension && extension.uninstall();
		}

		public function initialize(callback:Function):void
		{
			initializing && throwInitializedError();
			initializing = true;

			completeCallback = callback;

			findPreProcessors();
			if (preProcessorClasses.length > 0)
			{
				logger.info(this, 'Running context pre-processors');
				preProcessorCallback();
			}
			else
			{
				logger.info(this, 'No context pre-processors found. Finishing initialization.');
				finish();
			}
		}

		public function destroy():void
		{
			destroyed && throwDestroyedError();
			destroyed = true;
			uninstallExtensions();
		}

		public function toString():String
		{
			return 'ExtensionManager';
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function findPreProcessors():void
		{
			for each (var extensionClass:Class in extensionClasses)
			{
				if (classImplements(extensionClass, IContextPreProcessor))
				{
					logger.info(this, 'Pre processor extension found: ', [extensionClass]);
					preProcessorClasses.push(extensionClass);
				}
			}
		}

		private function classImplements(type:Class, superType:Class):Boolean
		{
			const superQCN:String = getQualifiedClassName(superType);
			return describeType(type).factory.implementsInterface.(@type == superQCN).length() != 0;
		}

		private function preProcessorCallback(error:Object = null):void
		{
			if (error)
			{
				logger.error(this, 'Context pre processor error: ', [error]);
				throw new Error(error);
			}
			else if (preProcessorClasses.length > 0)
			{
				const preProcessorClass:Class = preProcessorClasses.shift();
				logger.info(this, 'Executing processor: {0}', [preProcessorClass]);
				const preProcessor:IContextPreProcessor = new preProcessorClass();
				extensionByClass[preProcessorClass] = preProcessor;
				preProcessor.preProcess(context, preProcessorCallback);
			}
			else
			{
				logger.info(this, 'No more pre processors to run. Continuing initialization.');
				finish();
			}
		}

		private function finish():void
		{
			installExtensions();
			initializeExtensions();
			initialized = true;
			completeCallback();
		}

		private function createExtension(extensionClass:Class):IContextExtension
		{
			const extension:IContextExtension = new extensionClass();
			extensionByClass[extensionClass] = extension;
			return extension;
		}

		private function installExtensions():void
		{
			for each (var extensionClass:Class in extensionClasses)
			{
				const extension:IContextExtension = extensionByClass[extensionClass] || createExtension(extensionClass);
				logger.info(this, 'Installing extension:', [extensionClass]);
				extension.install(context);
			}
		}

		private function initializeExtensions():void
		{
			for each (var extensionClass:Class in extensionClasses)
			{
				const extension:IContextExtension = extensionByClass[extensionClass];
				logger.info(this, 'Initializing extension:', [extensionClass]);
				extension.initialize();
			}
		}

		private function uninstallExtensions():void
		{
			// Note: uninstall in reverse order
			var extensionClass:Class;
			while (extensionClass = extensionClasses.pop())
			{
				const extension:IContextExtension = extensionByClass[extensionClass];
				delete extensionByClass[extensionClass];
				logger.info(this, 'Uninstalling extension:', [extensionClass]);
				extension.uninstall();
			}
		}

		private function throwInitializedError():void
		{
			const message:String = 'This manager has been initialized and is now locked.';
			logger.fatal(this, message);
			throw new IllegalOperationError(message);
		}

		private function throwDestroyedError():void
		{
			const message:String = 'This manager has been destroyed and is now dead.';
			logger.fatal(this, message);
			throw new IllegalOperationError(message);
		}
	}
}
