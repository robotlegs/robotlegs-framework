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

package org.robotlegs.core
{
	
	/**
	 * The interface definition for a RobotLegs CommandMap
	 */
	public interface ICommandMap
	{
		/**
		 * Map an <code>ICommand</code> Class to an Event type
		 * 
		 * @param type The Event type to listen for
		 * @param commandClass The <code>ICommand</code> Class to instantiate and execute
		 * @param oneshot Unmap the <code>ICommand</code> Class after execution?
		 */
		function mapEvent(type:String, commandClass:Class, oneshot:Boolean = false):void;
		
		/**
		 * Unmap an <code>ICommand</code> Class to Event type mapping
		 * 
		 * @param type The Event type
		 * @param commandClass The <code>ICommand</code> Class to unmap
		 */
		function unmapEvent(type:String, commandClass:Class):void;
		
		/**
		 * Check if an <code>ICommand</code> Class has been mapped to an Event type
		 * 
		 * @param type The Event type
		 * @param commandClass The <code>ICommand</code> Class
		 * @return Whether the <code>ICommand</code> is mapped to this Event type
		 */
		function hasEventCommand(type:String, commandClass:Class):Boolean;
	}
}