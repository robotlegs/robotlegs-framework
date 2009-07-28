package org.robotlegs.mvcs
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IMediator;
	import org.robotlegs.core.IMediatorFactory;
	import org.robotlegs.core.IReflector;
	import org.robotlegs.utils.DelayedFunctionQueue;
	
	public class MediatorFactory implements IMediatorFactory
	{
		protected var contextView:DisplayObject;
		protected var injector:IInjector;
		protected var reflector:IReflector;
		protected var useCapture:Boolean;
		
		protected var mediatorByView:Dictionary;
		protected var mappingConfigByView:Dictionary;
		protected var mappingConfigByViewClassName:Dictionary;
		protected var localViewClassByViewClassName:Dictionary;
		
		/**
		 * Default MVCS <code>IMediatorFactory</code> implementation
		 * @param contextView The root view node of the context. The context will listen for ADDED_TO_STAGE events on this node
		 * @param injector An <code>IInjector</code> to use for this context
		 * @param reflector An <code>IReflector</code> to use for this context
		 * @param useCapture Optional, change at your peril!
		 */
		public function MediatorFactory(contextView:DisplayObject, injector:IInjector, reflector:IReflector, useCapture:Boolean = true)
		{
			this.contextView = contextView;
			this.injector = injector;
			this.reflector = reflector;
			this.useCapture = useCapture;
			
			this.mediatorByView = new Dictionary(true);
			this.mappingConfigByView = new Dictionary(true);
			this.mappingConfigByViewClassName = new Dictionary(false);
			
			initializeListeners();
		}
		
		public function mapMediator(viewClassOrName:Object, mediatorClass:Class, autoRegister:Boolean = true, autoRemove:Boolean = true):void
		{
			var viewClassName:String = reflector.getFQCN(viewClassOrName);
			if (mappingConfigByViewClassName[viewClassName] != null)
			{
				throw new ContextError(ContextError.E_MAP_EXISTS + ' - ' + mediatorClass);
			}
			if (reflector.classExtendsOrImplements(mediatorClass, IMediator) == false)
			{
				throw new ContextError(ContextError.E_MAP_NOIMPL + ' - ' + mediatorClass);
			}
			var config:MapppingConfig = new MapppingConfig();
			config.mediatorClass = mediatorClass;
			config.autoRegister = autoRegister;
			config.autoRemove = autoRemove;
			config.typedViewClass = null;
			mappingConfigByViewClassName[viewClassName] = config;
		}
		
		public function mapModuleMediator(moduleClassName:String, localModuleClass:Class, mediatorClass:Class, autoRegister:Boolean = true, autoRemove:Boolean = true):void
		{
			mapMediator(moduleClassName, mediatorClass, autoRegister, autoRemove);
			var config:MapppingConfig = mappingConfigByViewClassName[moduleClassName];
			config.typedViewClass = localModuleClass;
		}
		
		public function createMediator(viewComponent:Object):IMediator
		{
			var mediator:IMediator = mediatorByView[viewComponent];
			if (mediator == null)
			{
				var viewClass:Class = reflector.getClass(viewComponent);
				var viewClassName:String = reflector.getFQCN(viewComponent);
				var config:MapppingConfig = mappingConfigByViewClassName[viewClassName];
				if (config)
				{
					var typedViewClass:Class = (config.typedViewClass) ? config.typedViewClass : viewClass;
					var mediatorClass:Class = config.mediatorClass;
					mediator = new mediatorClass();
					// Use a logging interface
					trace('[ROBOTLEGS] Mediator Constructed: (' + mediator + ') with View Component (' + viewComponent + ')');
					injector.bindValue(typedViewClass, viewComponent);
					injector.injectInto(mediator);
					injector.unbind(typedViewClass);
					registerMediator(mediator, viewComponent);
				}
			}
			return mediator;
		}
		
		public function registerMediator(mediator:IMediator, viewComponent:Object):void
		{
			injector.bindValue(reflector.getClass(mediator), mediator);
			mediatorByView[viewComponent] = mediator;
			mappingConfigByView[viewComponent] = mappingConfigByViewClassName[reflector.getFQCN(viewComponent)];
			mediator.setViewComponent(viewComponent);
			mediator.preRegister();
			// Use a logging interface
			trace('[ROBOTLEGS] Mediator Registered: (' + mediator + ') with View Component (' + viewComponent + ')');
		}
		
		public function removeMediator(mediator:IMediator):IMediator
		{
			if (mediator)
			{
				var viewComponent:Object = mediator.getViewComponent();
				delete mediatorByView[viewComponent];
				delete mappingConfigByView[viewComponent];
				mediator.preRemove();
				mediator.setViewComponent(null);
				// injector.unbind( reflector.getClass( viewComponent ) );
				injector.unbind(reflector.getClass(mediator));
				// injector.injectInto( mediator );
				// Use a logging interface
				trace('[ROBOTLEGS] Mediator Removed: (' + mediator + ') with View Component (' + viewComponent + ')');
			}
			return mediator;
		}
		
		public function removeMediatorByView(viewComponent:Object):IMediator
		{
			return removeMediator(retrieveMediator(viewComponent));
		}
		
		public function retrieveMediator(viewComponent:Object):IMediator
		{
			return mediatorByView[viewComponent];
		}
		
		public function hasMediator(viewComponent:Object):Boolean
		{
			return mediatorByView[viewComponent] != null;
		}
		
		public function destroy():void
		{
			removeListeners();
			injector = null;
			mediatorByView = null;
			mappingConfigByView = null;
			mappingConfigByViewClassName = null;
			contextView = null;
		}
		
		// Protected Methods //////////////////////////////////////////////////
		protected function initializeListeners():void
		{
			contextView.addEventListener(Event.ADDED_TO_STAGE, onViewAdded, useCapture, 0, true);
			contextView.addEventListener(Event.REMOVED_FROM_STAGE, onViewRemoved, useCapture, 0, true);
		}
		
		protected function removeListeners():void
		{
			contextView.removeEventListener(Event.ADDED_TO_STAGE, onViewAdded, useCapture);
			contextView.removeEventListener(Event.REMOVED_FROM_STAGE, onViewRemoved, useCapture);
		}
		
		protected function onViewAdded(e:Event):void
		{
			var config:MapppingConfig = mappingConfigByViewClassName[reflector.getFQCN(e.target)];
			if (config && config.autoRegister)
			{
				createMediator(e.target);
			}
		}
		
		protected function onViewRemoved(e:Event):void
		{
			var config:MapppingConfig = mappingConfigByView[e.target];
			if (config && config.autoRemove)
			{
				// Use a logging interface
				trace('[ROBOTLEGS] MediatorFactory might have mistakenly lost an ' + e.target + ', double checking...');
				// Flex work-around...
				DelayedFunctionQueue.add(possiblyRemoveMediator, e.target);
			}
		}
		
		// Private Methods ////////////////////////////////////////////////////
		private function possiblyRemoveMediator(viewComponent:DisplayObject):void
		{
			if (viewComponent.stage == null)
			{
				removeMediatorByView(viewComponent);
			}
			else
			{
				// Use a logging interface
				trace('[ROBOTLEGS] False alarm for ' + viewComponent);
			}
		}
	
	}

}

class MapppingConfig
{
	public var mediatorClass:Class;
	public var typedViewClass:Class;
	public var autoRegister:Boolean;
	public var autoRemove:Boolean;
}
