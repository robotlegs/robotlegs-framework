/*
 * Copyright (c) 2009 the original author or authors
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package org.robotlegs.base
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IMediator;
	import org.robotlegs.core.IMediatorMap;
	import org.robotlegs.core.IReflector;
	
	/**
	 * An abstract <code>IMediatorMap</code> implementation
	 */
	public class MediatorMap implements IMediatorMap
	{
		protected static const enterFrameDispatcher:Sprite = new Sprite();
		
		protected var _enabled:Boolean = true;
		protected var _contextView:DisplayObjectContainer;
		protected var injector:IInjector;
		protected var reflector:IReflector;
		protected var useCapture:Boolean;
		
		protected var mediatorByView:Dictionary;
		protected var mappingConfigByView:Dictionary;
		protected var mappingConfigByViewClassName:Dictionary;
		protected var localViewClassByViewClassName:Dictionary;
		
		protected var mediatorsMarkedForRemoval:Dictionary;
		protected var hasMediatorsMarkedForRemoval:Boolean;
		
		/**
		 * Creates a new <code>MediatorMap</code> object
		 *
		 * @param contextView The root view node of the context. The context will listen for ADDED_TO_STAGE events on this node
		 * @param injector An <code>IInjector</code> to use for this context
		 * @param reflector An <code>IReflector</code> to use for this context
		 * @param useCapture Optional, change at your peril!
		 */
		public function MediatorMap(contextView:DisplayObjectContainer, injector:IInjector, reflector:IReflector, useCapture:Boolean = true)
		{
			this.injector = injector;
			this.reflector = reflector;
			this.useCapture = useCapture;
			
			this.mediatorByView = new Dictionary(true);
			this.mappingConfigByView = new Dictionary(true);
			this.mappingConfigByViewClassName = new Dictionary(false);
			
			this.mediatorsMarkedForRemoval = new Dictionary(false);
			
			this.contextView = contextView;
		}
		
		/**
		 * @inheritDoc
		 */
		public function mapView(viewClassOrName:*, mediatorClass:Class, autoCreate:Boolean = true, autoRemove:Boolean = true):void
		{
			var viewClassName:String = reflector.getFQCN(viewClassOrName);
			var contextViewClassName:String = reflector.getFQCN(contextView)
			if (mappingConfigByViewClassName[viewClassName] != null)
			{
				throw new ContextError(ContextError.E_MEDIATORMAP_OVR + ' - ' + mediatorClass);
			}
			if (reflector.classExtendsOrImplements(mediatorClass, IMediator) == false)
			{
				throw new ContextError(ContextError.E_MEDIATORMAP_NOIMPL + ' - ' + mediatorClass);
			}
			var config:MappingConfig = new MappingConfig();
			config.mediatorClass = mediatorClass;
			config.autoCreate = autoCreate;
			config.autoRemove = autoRemove;
			if (viewClassOrName is Class)
			{
				config.typedViewClass = viewClassOrName;
			}
			mappingConfigByViewClassName[viewClassName] = config;
			if (autoCreate && contextViewClassName == viewClassName)
			{
				createMediator(contextView);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function mapModule(moduleClassName:String, localModuleClass:Class, mediatorClass:Class, autoCreate:Boolean = true, autoRemove:Boolean = true):void
		{
			mapView(moduleClassName, mediatorClass, autoCreate, autoRemove);
			var config:MappingConfig = mappingConfigByViewClassName[moduleClassName];
			config.typedViewClass = localModuleClass;
		}
		
		/**
		 * @inheritDoc
		 */
		public function createMediator(viewComponent:Object):IMediator
		{
			var mediator:IMediator = mediatorByView[viewComponent];
			if (mediator == null)
			{
				var viewClassName:String = reflector.getFQCN(viewComponent);
				var config:MappingConfig = mappingConfigByViewClassName[viewClassName];
				if (config)
				{
					injector.mapValue(config.typedViewClass, viewComponent);
					mediator = injector.instantiate(config.mediatorClass);
					injector.unmap(config.typedViewClass);
					registerMediator(viewComponent, mediator);
				}
			}
			return mediator;
		}
		
		/**
		 * @inheritDoc
		 */
		public function registerMediator(viewComponent:Object, mediator:IMediator):void
		{
			injector.mapValue(reflector.getClass(mediator), mediator);
			mediatorByView[viewComponent] = mediator;
			mappingConfigByView[viewComponent] = mappingConfigByViewClassName[reflector.getFQCN(viewComponent)];
			mediator.setViewComponent(viewComponent);
			mediator.preRegister();
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeMediator(mediator:IMediator):IMediator
		{
			if (mediator)
			{
				var viewComponent:Object = mediator.getViewComponent();
				delete mediatorByView[viewComponent];
				delete mappingConfigByView[viewComponent];
				mediator.preRemove();
				mediator.setViewComponent(null);
				injector.unmap(reflector.getClass(mediator));
			}
			return mediator;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeMediatorByView(viewComponent:Object):IMediator
		{
			return removeMediator(retrieveMediator(viewComponent));
		}
		
		/**
		 * @inheritDoc
		 */
		public function retrieveMediator(viewComponent:Object):IMediator
		{
			return mediatorByView[viewComponent];
		}
		
		/**
		 * @inheritDoc
		 */
		public function hasMediatorForView(viewComponent:Object):Boolean
		{
			return mediatorByView[viewComponent] != null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function hasMediator(mediator:IMediator):Boolean
		{
			for each (var med:IMediator in mediatorByView)
			{
				if (med == mediator)
				{
					return true;
				}
			}
			return false;
		}
		
		public function get contextView():DisplayObjectContainer
		{
			return _contextView;
		}
		
		public function set contextView(value:DisplayObjectContainer):void
		{
			if (value != _contextView)
			{
				removeListeners();
				_contextView = value;
				addListeners();
			}
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			if (value != _enabled)
			{
				removeListeners();
				_enabled = value;
				addListeners();
			}
		}
		
		// Protected Methods //////////////////////////////////////////////////
		
		protected function addListeners():void
		{
			if (contextView && enabled)
			{
				contextView.addEventListener(Event.ADDED_TO_STAGE, onViewAdded, useCapture, 0, true);
				contextView.addEventListener(Event.REMOVED_FROM_STAGE, onViewRemoved, useCapture, 0, true);
			}
		}
		
		protected function removeListeners():void
		{
			if (contextView && enabled)
			{
				contextView.removeEventListener(Event.ADDED_TO_STAGE, onViewAdded, useCapture);
				contextView.removeEventListener(Event.REMOVED_FROM_STAGE, onViewRemoved, useCapture);
			}
		}
		
		protected function onViewAdded(e:Event):void
		{
			if (mediatorsMarkedForRemoval[e.target])
			{
				delete mediatorsMarkedForRemoval[e.target];
				return;
			}
			var config:MappingConfig = mappingConfigByViewClassName[reflector.getFQCN(e.target)];
			if (config && config.autoCreate)
			{
				createMediator(e.target);
			}
		}
		
		/**
		 * Flex framework work-around part #5
		 */
		protected function onViewRemoved(e:Event):void
		{
			var config:MappingConfig = mappingConfigByView[e.target];
			if (config && config.autoRemove)
			{
				mediatorsMarkedForRemoval[e.target] = e.target;
				if (!hasMediatorsMarkedForRemoval)
				{
					hasMediatorsMarkedForRemoval = true;
					enterFrameDispatcher.addEventListener(Event.ENTER_FRAME, removeMediatorLater);
				}
			}
		}
		
		/**
		 * Flex framework work-around part #6
		 */
		private function removeMediatorLater(event:Event):void
		{
			enterFrameDispatcher.removeEventListener(Event.ENTER_FRAME, removeMediatorLater);
			for each (var view:DisplayObject in mediatorsMarkedForRemoval)
			{
				if (!view.stage)
				{
					removeMediatorByView(view);
				}
				delete mediatorsMarkedForRemoval[view];
			}
			hasMediatorsMarkedForRemoval = false;
		}
	}
}

class MappingConfig
{
	public var mediatorClass:Class;
	public var typedViewClass:Class;
	public var autoCreate:Boolean;
	public var autoRemove:Boolean;
}
