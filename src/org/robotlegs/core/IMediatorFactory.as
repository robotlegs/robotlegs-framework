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
	 * The interface definition for a RobotLegs MediatorFactory
	 */
	public interface IMediatorFactory
	{
		
		/**
		 * Map an <code>IMediator</code> to a view Class
		 * @param viewClass The concrete view Class or Fully Qualified Class Name (<code>flash.utils.getQualifiedClassName</code>::style)
		 * @param mediatorClass The <code>IMediator</code> Class
		 * @param autoRegister Automatically construct and register an instance of Class <code>mediatorClass</code> when an instance of Class <code>viewClass</code> is detected
		 * @param autoRemove Automatically remove an instance of Class <code>mediatorClass</code> when it's <code>viewClass</code> leaves the ancestory of the context view
		 */
		function mapMediator(viewClassOrName:Object, mediatorClass:Class, autoRegister:Boolean = true, autoRemove:Boolean = true):void
		
		/**
		 * Map an <code>IMediator</code> to a flex module
		 * @param moduleClassName Fully Qualified Class Name of the Module (<code>flash.utils.getQualifiedClassName</code>::style)
		 * @param localModuleClass The local Class (Interface) to be inject
		 * @param mediatorClass The <code>IMediator</code> Class
		 * @param autoRegister Automatically construct and register an instance of Class <code>mediatorClass</code> when an instance of Class <code>moduleClassName</code> is detected
		 * @param autoRemove Automatically remove an instance of Class <code>mediatorClass</code> when it's <code>viewClass</code> leaves the ancestory of the context view
		 */
		function mapModuleMediator(moduleClassName:String, localModuleClass:Class, mediatorClass:Class, autoRegister:Boolean = true, autoRemove:Boolean = true):void
		
		/**
		 * Create an instance of a mapped <code>IMediator</code>
		 * @param viewComponent An instance of the view Class previously mapped to an <code>IMediator</code> Class
		 * @return The <code>IMediator</code>
		 */
		function createMediator(viewComponent:Object):IMediator;
		
		/**
		 * Manually register an <code>IMediator</code> instance
		 * @param mediator The <code>IMediator</code> to register
		 * @param viewComponent The view component for the <code>IMediator</code>
		 */
		function registerMediator(mediator:IMediator, viewComponent:Object):void;
		
		/**
		 * Remove a registered <code>IMediator</code> instance
		 * @param mediator The <code>IMediator</code> to remove
		 * @return The <code>IMediator</code> that was removed
		 */
		function removeMediator(mediator:IMediator):IMediator;
		
		/**
		 * Remove a registered <code>IMediator</code> instance
		 * @param viewComponent The view that the <code>IMediator</code> was registered with
		 * @return The <code>IMediator</code> that was removed
		 */
		function removeMediatorByView(viewComponent:Object):IMediator;
		
		/**
		 * Retrieve a registered <code>IMediator</code> instance
		 * @param viewComponent The view that the <code>IMediator</code> was registered with
		 * @return The <code>IMediator</code>
		 */
		function retrieveMediator(viewComponent:Object):IMediator;
		
		/**
		 * Check if an <code>IMediator</code> has been registered for a view instance
		 * @param viewComponent The view that the <code>IMediator</code> was registered with
		 * @return Whether an <code>IMediator</code> has been registered for this view instance
		 */
		function hasMediator(viewComponent:Object):Boolean;
	
	}
}