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
	import flash.utils.getQualifiedClassName;
	
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IViewMap;
	
	/**
	 * An abstract <code>IViewMap</code> implementation
	 */
	public class ViewMap extends ViewMapBase implements IViewMap
	{
		protected var mappedPackages:Array;
		protected var mappedTypes:Dictionary;
		
		protected var injectedViews:Dictionary;
		
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
		public function ViewMap(contextView:DisplayObjectContainer, injector:IInjector)
		{
			super(contextView, injector);
			
			// mappings - if you can do it with fewer dictionaries you get a prize
			this.mappedPackages = new Array();
			this.mappedTypes = new Dictionary(false);
			this.injectedViews = new Dictionary(true);
		}
		
		//---------------------------------------------------------------------
		// API
		//---------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function mapPackage(packageName:String):void
		{
			if (mappedPackages.indexOf(packageName) == -1)
			{
				mappedPackages.push(packageName);
				activate();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function unmapPackage(packageName:String):void
		{
			var index:int = mappedPackages.indexOf(packageName);
			if (index > -1)
			{
				mappedPackages.splice(index, 1);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function mapType(type:Class):void
		{
			if (mappedTypes[type])
			{
				return;
			}
			
			mappedTypes[type] = type;
			
			if (contextView && (contextView is type))
			{
				injectInto(contextView);
			}
			
			activate();
		}
		
		/**
		 * @inheritDoc
		 */
		public function unmapType(type:Class):void
		{
			delete mappedTypes[type];
		}
		
		/**
		 * @inheritDoc
		 */
		public function hasType(type:Class):Boolean
		{
			return (mappedTypes[type] != null);
		}
				
		/**
		 * @inheritDoc
		 */
		public function hasPackage(packageName:String):Boolean
		{
			return mappedPackages.indexOf(packageName) > -1;
		}
		
		//---------------------------------------------------------------------
		// Internal
		//---------------------------------------------------------------------
		
		/**
		 * @private
		 */
		protected override function addListeners():void
		{
			if (contextView && enabled && _active)
			{
				contextView.addEventListener(Event.ADDED_TO_STAGE, onViewAdded, useCapture, 0, true);
			}
		}
		
		/**
		 * @private
		 */
		protected override function removeListeners():void
		{
			if (contextView && enabled && _active)
			{
				contextView.removeEventListener(Event.ADDED_TO_STAGE, onViewAdded, useCapture);
			}
		}
		
		/**
		 * @private
		 */
		protected override function onViewAdded(e:Event):void
		{
			if (injectedViews[e.target])
			{
				return;
			}
			
			for each (var type:Class in mappedTypes)
			{
				if (e.target is type)
				{
					injectInto(e.target);
					return;
				}
			}
			
			var len:int = mappedPackages.length;
			if (len > 0)
			{
				var className:String = getQualifiedClassName(e.target);
				for (var i:int = 0; i < len; i++)
				{
					var packageName:String = mappedPackages[i];
					if (className.indexOf(packageName) == 0)
					{
						injectInto(e.target);
						return;
					}
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
