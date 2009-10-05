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

package org.robotlegs.mvcs
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import org.robotlegs.base.MediatorBase;
	import org.robotlegs.core.IMediator;
	import org.robotlegs.core.IMediatorMap;
	import org.robotlegs.core.IPropertyProvider;
	
	/**
	 * Abstract MVCS <code>IMediator</code> and <code>IPropertyProvider</code> implementation
	 */
	public class Mediator extends MediatorBase implements IPropertyProvider
	{
		[Inject(name='mvcsContextView')]
		public var contextView:DisplayObjectContainer;
		
		[Inject(name='mvcsMediatorMap')]
		public var mediatorMap:IMediatorMap;
		
		[Inject(name='mvcsEventDispatcher')]
		public var eventDispatcher:IEventDispatcher;
		
		public function Mediator()
		{
			super();
		}
		
		/**
		 * Walk up the Display List looking for view components that have corresponding Mediators in this Context
		 * Ask each Mediator for a named, typed property, and return the first non-null result
		 *
		 * This mechanism is evil. A better solution is sorely needed.
		 *
		 * @param name The name of the property you are looking for
		 * @param type The type of property you are looking for
		 * @return The returned value
		 */
		public function findProperty(name:String, type:*):*
		{
			var val:*;
			var viewDo:DisplayObject = getViewComponent() as DisplayObject;
			var parent:DisplayObjectContainer;
			var parentMediator:IMediator;
			var parentProvider:IPropertyProvider;
			while ((parent = viewDo.parent))
			{
				if ((parentMediator = mediatorMap.retrieveMediator(parent)))
				{
					if ((parentProvider = parentMediator as IPropertyProvider) && (val = parentProvider.provideProperty(name, type)))
					{
						return val;
					}
				}
				viewDo = parent;
			}
			return null;
		}
		
		/**
		 * dispatchEvent Helper method
		 *
		 * The same as calling <code>dispatchEvent</code> directly on the <code>IEventDispatcher</code>.
		 *
		 * @param event The <code>Event</code> to dispatch on the <code>IEventDispatcher</code>
		 */
		protected function dispatch(event:Event):void
		{
			eventDispatcher.dispatchEvent(event);
		}
	
	}
}