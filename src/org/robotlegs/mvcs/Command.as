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
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import org.robotlegs.core.ICommand;
	import org.robotlegs.core.ICommandFactory;
	import org.robotlegs.core.IEventBroadcaster;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IMediatorFactory;
	
	/**
	 * Abstract MVCS <code>ICommand</code> implementation
	 */
	public class Command implements ICommand
	{
		[Inject(name='mvcsContextView')]
		public var contextView:DisplayObjectContainer;
		
		[Inject(name='mvcsCommandFactory')]
		public var commandFactory:ICommandFactory;
		
		[Inject(name='mvcsEventBroadcaster')]
		public var eventBroadcaster:IEventBroadcaster;
		
		[Inject(name='mvcsInjector')]
		public var injector:IInjector;
		
		[Inject(name='mvcsMediatorFactory')]
		public var mediatorFactory:IMediatorFactory;
		
		public function Command()
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function execute():void
		{
		}
		
		/**
		 * A helper method to dispatch Events on the default Event Broadcaster
		 * @param event The Event to dispatch
		 */
		protected function dispatch(event:Event):void
		{
			eventBroadcaster.dispatchEvent(event);
		}
		
	}
}