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
	 * The interface definition for a RobotLegs Mediator
	 */
	public interface IMediator
	{
		/**
		 * Should be invoked by the <code>IMediatorFactory</code> when the <code>IMediator</code> has been registered
		 */
		function preRegister():void;
		
		/**
		 * Should be invoked by the <code>IMediator</code> itself when it is ready to be interacted with
		 * Override and place your initialization code here
		 */
		function onRegister():void;
		
		/**
		 * Invoked when the <code>IMediator</code> has been removed by the <code>IMediatorFactory</code>
		 */
		function preRemove():void;
		
		/**
		 * Should be invoked by the <code>IMediator</code> itself when it is ready to for cleanup
		 * Override and place your cleanup code here
		 */
		function onRemove():void;
		
		/**
		 * Get the <code>IMediator</code>'s view component
		 * @return The view component
		 */
		function getViewComponent():Object;
		
		/**
		 * Set the <code>IMediator</code>'s view component
		 * @param The view component
		 */
		function setViewComponent(viewComponent:Object):void;
	
	}
}