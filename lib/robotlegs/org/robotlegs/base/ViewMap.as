/*
 * Copyright (c) 2009, 2010 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package org.robotlegs.base
{
	import flash.display.DisplayObject;
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
		/**
		 * @private
		 */
		protected var mappedPackages:Array;

		/**
		 * @private
		 */
		protected var mappedTypes:Dictionary;

		/**
		 * @private
		 */
		protected var injectedViews:Dictionary;

		//---------------------------------------------------------------------
		// Constructor
		//---------------------------------------------------------------------

		/**
		 * Creates a new <code>ViewMap</code> object
		 *
		 * @param contextView The root view node of the context. The map will listen for ADDED_TO_STAGE events on this node
		 * @param injector An <code>IInjector</code> to use for this context
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
				viewListenerCount++;
				if (viewListenerCount == 1)
					addListeners();
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
				viewListenerCount--;
				if (viewListenerCount == 0)
					removeListeners();
			}
		}

		/**
		 * @inheritDoc
		 */
		public function mapType(type:Class):void
		{
			if (mappedTypes[type])
				return;

			mappedTypes[type] = type;

			viewListenerCount++;
			if (viewListenerCount == 1)
				addListeners();

			// This was a bad idea - causes unexpected eager instantiation of object graph 
			if (contextView && (contextView is type))
				injectInto(contextView);
		}

		/**
		 * @inheritDoc
		 */
		public function unmapType(type:Class):void
		{
			var mapping:Class = mappedTypes[type];
			delete mappedTypes[type];
			if (mapping)
			{
				viewListenerCount--;
				if (viewListenerCount == 0)
					removeListeners();
			}
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
			if (contextView && enabled)
				contextView.addEventListener(Event.ADDED_TO_STAGE, onViewAdded, useCapture, 0, true);
		}

		/**
		 * @private
		 */
		protected override function removeListeners():void
		{
			if (contextView)
				contextView.removeEventListener(Event.ADDED_TO_STAGE, onViewAdded, useCapture);
		}

		/**
		 * @private
		 */
		protected override function onViewAdded(e:Event):void
		{
			var target:DisplayObject = DisplayObject(e.target);
			if (injectedViews[target])
				return;

			for each (var type:Class in mappedTypes)
			{
				if (target is type)
				{
					injectInto(target);
					return;
				}
			}

			var len:int = mappedPackages.length;
			if (len > 0)
			{
				var className:String = getQualifiedClassName(target);
				for (var i:int = 0; i < len; i++)
				{
					var packageName:String = mappedPackages[i];
					if (className.indexOf(packageName) == 0)
					{
						injectInto(target);
						return;
					}
				}
			}
		}

		protected function injectInto(target:DisplayObject):void
		{
			injector.injectInto(target);
			injectedViews[target] = true;
		}
	}
}
