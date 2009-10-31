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
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.getDefinitionByName;
	
	import org.robotlegs.core.IMediator;
	
	/**
	 * An abstract <code>IMediator</code> implementation
	 */
	public class MediatorBase implements IMediator
	{
		/**
		 * Flex framework work-around part #1
		 */
		private static var UIComponentClass:Class;
		
		/**
		 * Flex framework work-around part #2
		 */
		private static const flexAvailable:Boolean = checkFlex();
		
		/**
		 * Internal
		 *
		 * <p>This Mediator's View Component, used by the RobotLegs MVCS framework internally.
		 * You should declare a dependency on a concrete view component in your
		 * implementation instead of working with this property</p>
		 */
		protected var viewComponent:Object;
		
		/**
		 * Creates a new <code>Mediator</code> object
		 */
		public function MediatorBase()
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function preRegister():void
		{
			if (flexAvailable && (viewComponent is UIComponentClass) && !viewComponent['initialized'])
			{
				IEventDispatcher(viewComponent).addEventListener('creationComplete', onCreationComplete, false, 0, true);
			}
			else
			{
				onRegister();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function onRegister():void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function preRemove():void
		{
			onRemove();
		}
		
		/**
		 * @inheritDoc
		 */
		public function onRemove():void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function getViewComponent():Object
		{
			return viewComponent;
		}
		
		/**
		 * @inheritDoc
		 */
		public function setViewComponent(viewComponent:Object):void
		{
			this.viewComponent = viewComponent;
		}
		
		/**
		 * Flex framework work-around part #3
		 *
		 * <p>Checks for availability of the Flex framework by trying to get the class for UIComponent.</p>
		 */
		private static function checkFlex():Boolean
		{
			try
			{
				UIComponentClass = getDefinitionByName('mx.core::UIComponent') as Class;
			}
			catch (error:Error)
			{
				// do nothing
			}
			return UIComponentClass != null;
		}
		
		/**
		 * Flex framework work-around part #4
		 *
		 * <p><code>FlexEvent.CREATION_COMPLETE</code> handler for this Mediator's View Component</p>
		 *
		 * @param e The Flex <code>FlexEvent</code> event
		 */
		private function onCreationComplete(e:Event):void
		{
			IEventDispatcher(e.target).removeEventListener('creationComplete', onCreationComplete);
			onRegister();
		}
	}
}
