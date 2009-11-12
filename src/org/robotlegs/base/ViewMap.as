/*
 * Copyright (c) 2009 the original author or authors
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package org.robotlegs.base
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IReflector;
	import org.robotlegs.core.IViewMap;
	
	/**
	 * An abstract <code>IViewMap</code> implementation
	 */
	public class ViewMap implements IViewMap
	{
		protected var _enabled:Boolean = true;
		protected var _contextView:DisplayObjectContainer;
		
		protected var injector:IInjector;
		protected var reflector:IReflector;
		protected var useCapture:Boolean;
		
		protected var mappedClassNames:Dictionary;
		protected var injectedViews:Dictionary;
		
		//---------------------------------------------------------------------
		//  Constructor
		//---------------------------------------------------------------------
		
		/**
		 * Creates a new <code>ViewMap</code> object
		 *
		 * @param contextView The root view node of the context. The map will listen for ADDED_TO_STAGE events on this node
		 * @param injector An <code>IInjector</code> to use for this context
		 * @param reflector An <code>IReflector</code> to use for this context
		 */
		public function ViewMap(contextView:DisplayObjectContainer, injector:IInjector, reflector:IReflector)
		{
			this.injector = injector;
			this.reflector = reflector;
			
			// mappings - if you can do with fewer dictionaries you get a prize
			this.mappedClassNames = new Dictionary(false);
			this.injectedViews = new Dictionary(true);
			
			// change this at your peril lest ye understand the problem and have a better solution
			this.useCapture = true;
			
			// this must come last, see the setter
			this.contextView = contextView;
		}
		
		//---------------------------------------------------------------------
		//  API
		//---------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function mapClass(viewClassOrName:*):void
		{
			var viewClassName:String = reflector.getFQCN(viewClassOrName);
			if(viewClassOrName is String)
				viewClassOrName = reflector.getClass(viewClassOrName);
			if (mappedClassNames[viewClassOrName])
			{
				return;
			}
			
			mappedClassNames[viewClassOrName] = true;
			
			if (contextView && (viewClassName == reflector.getFQCN(contextView)))
			{
				injector.injectInto(contextView);
				injectedViews[contextView] = true;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function unmapClass(viewClassOrName:*):void
		{
			if(viewClassOrName is String)
				viewClassOrName = reflector.getClass(viewClassOrName);
			delete mappedClassNames[viewClassOrName];
		}
		
		/**
		 * @inheritDoc
		 */
		public function hasClass(viewClassOrName:*):Boolean
		{
			if(viewClassOrName is String)
				viewClassOrName = reflector.getClass(viewClassOrName);
			return mappedClassNames[viewClassOrName];
		}
		
		/**
		 * @inheritDoc
		 */
		public function get contextView():DisplayObjectContainer
		{
			return _contextView;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set contextView(value:DisplayObjectContainer):void
		{
			if (value != _contextView)
			{
				removeListeners();
				_contextView = value;
				addListeners();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set enabled(value:Boolean):void
		{
			if (value != _enabled)
			{
				removeListeners();
				_enabled = value;
				addListeners();
			}
		}
		
		//---------------------------------------------------------------------
		//  Internal
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected function addListeners():void
		{
			if (contextView && enabled)
			{
				contextView.addEventListener(Event.ADDED_TO_STAGE, onViewAdded, useCapture, 0, true);
			}
		}
		
		/**
		 * @private
		 */
		protected function removeListeners():void
		{
			if (contextView && enabled)
			{
				contextView.removeEventListener(Event.ADDED_TO_STAGE, onViewAdded, useCapture);
			}
		}
		
		/**
		 * @private
		 */
		protected function onViewAdded(e:Event):void
		{
			for(var test:* in mappedClassNames)
			{
				var targetClass:Class = reflector.getClass(e.target);
				var targetIsMapped:Boolean = reflector.classExtendsOrImplements(targetClass, test);
				if( targetIsMapped && !injectedViews[e.target])
				{
					injector.injectInto(e.target);
					injectedViews[e.target] = true;
					break;
				}
			}
		}
	}
}
