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
			this.mappedInterfaces = new Dictionary(false);
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
		public function unmapClass(viewClassOrName:*):void
		{
			var viewClassName:String = reflector.getFQCN(viewClassOrName);
			delete mappedClassNames[viewClassName];
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
		}
		
		protected function injectInto(target:*):void
		{
			injector.injectInto(target);
			injectedViews[target] = true;
		}
	}
}
