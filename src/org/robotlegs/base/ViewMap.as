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
		protected var mappedInterfaces:Dictionary;
		
		protected var injectedViews:Dictionary;
		protected var packageNames:Array;
		
		//---------------------------------------------------------------------
		// Constructor
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
			
			// mappings - if you can do it with fewer dictionaries you get a prize
			this.mappedClassNames = new Dictionary(false);
			this.mappedInterfaces = new Dictionary(false);
			this.injectedViews = new Dictionary(true);
			this.packageNames = new Array();
			
			// change this at your peril lest ye understand the problem and have a better solution
			this.useCapture = true;
			
			// this must come last, see the setter
			this.contextView = contextView;
		}
		
		//---------------------------------------------------------------------
		// API
		//---------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function mapClass(viewClassOrName:*):void
		{
			var viewClassName:String = reflector.getFQCN(viewClassOrName);
			
			if (mappedClassNames[viewClassName])
			{
				return;
			}
			
			mappedClassNames[viewClassName] = true;
			
			if (contextView && (viewClassName == reflector.getFQCN(contextView)))
			{
				injector.injectInto(contextView);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function mapPackage(packageName:String):void
		{
			if (packageNames.indexOf(packageName) == -1)
			{
				packageNames.push(packageName);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function unmapClass(viewClassOrName:*):void
		{
			var viewClassName:String = reflector.getFQCN(viewClassOrName);
			delete mappedClassNames[viewClassName];
		}
		
		/**
		 * @inheritDoc
		 */
		public function unmapPackage(packageName:String):void
		{
			var index:int = packageNames.indexOf(packageName);
			if (index > -1)
			{
				packageNames.splice(index, 1);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function hasClass(viewClassOrName:*):Boolean
		{
			var viewClassName:String = reflector.getFQCN(viewClassOrName);
			return mappedClassNames[viewClassName];
		}
		
		/**
		 * @inheritDoc
		 */
		public function mapInterface(type:Class):void
		{
			if (mappedInterfaces[type])
			{
				return;
			}
			
			mappedInterfaces[type] = type;
			
			if (contextView && (contextView is type))
			{
				injector.injectInto(contextView);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function unmapInterface(type:Class):void
		{
			delete mappedInterfaces[type];
		}
		
		/**
		 * @inheritDoc
		 */
		public function hasInterface(type:Class):Boolean
		{
			return (mappedInterfaces[type] != null);
		}
				
		
		
		
		
		
		
		/**
		 * @inheritDoc
		 */
		public function hasPackage(packageName:String):Boolean
		{
			return packageNames.indexOf(packageName) > -1;
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
		// Internal
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
			if (injectedViews[e.target])
			{
				return;
			}
			
			if (mappedClassNames[reflector.getFQCN(e.target)]) 
			{
				injectInto(e.target);
			}
			else 
			{
				for each (var type:Class in mappedInterfaces)
				{
					if (e.target is type)
					{
						injectInto(e.target);
					}
				}
			}
			
			var packageName:String;
			var len:int = packageNames.length;
			for (var i:int = 0; i < len; i++)
			{
				packageName = packageNames[i];
				if (packageName == className.substr(0, packageName.length))
				{
					injector.injectInto(e.target);
					injectedViews[e.target] = true;
					return;
				}
			}
		}
		
		protected function injectInto(target:*):void
		{
			injector.injectInto(target);
			injectedViews[target] = true;
		}
	}
}
