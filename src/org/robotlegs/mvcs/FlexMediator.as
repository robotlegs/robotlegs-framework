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
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	/**
	 * Abstract MVCS Flex <code>IMediator</code> implementation
	 */
	public class FlexMediator extends Mediator
	{
		/**
		 * Internal
		 * A typed reference to the View Component
		 */
		private var uiComponent:UIComponent;
		
		/**
		 * Creates a new <code>FlexMediator</code> object
		 */
		public function FlexMediator()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function preRegister():void
		{
			uiComponent = viewComponent as UIComponent;
			if (uiComponent.initialized)
			{
				onRegister();
			}
			else
			{
				uiComponent.addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete, false, 0, true);
			}
		}
		
		/**
		 * FlexEvent.CREATION_COMPLETE handler for this Mediator's View Component
		 * @param e The Flex Event
		 */
		private function onCreationComplete(e:FlexEvent):void
		{
			uiComponent.removeEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
			onRegister();
		}
	
	}

}