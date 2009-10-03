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
	 * The interface definition for a RobotLegs MediatorMap
	 */
	public interface IMediatorMap
	{
		
		/**
		 * Map an <code>IMediator</code> to a view Class
		 *
		 * @param viewClassOrName The concrete view Class or Fully Qualified Class Name (<code>flash.utils.getQualifiedClassName</code>::style)
		 * @param mediatorClass The <code>IMediator</code> Class
		 * @param autoCreate Automatically construct and register an instance of Class <code>mediatorClass</code> when an instance of Class <code>viewClass</code> is detected
		 * @param autoRemove Automatically remove an instance of Class <code>mediatorClass</code> when it's <code>viewClass</code> leaves the ancestory of the context view
		 */
		function mapView(viewClassOrName:*, mediatorClass:Class, autoCreate:Boolean = true, autoRemove:Boolean = true):void
		
		/**
		 * Map an <code>IMediator</code> to a module
		 *
		 * @param moduleClassName Fully Qualified Class Name of the Module (<code>flash.utils.getQualifiedClassName</code>::style)
		 * @param localModuleClass The local Class (Interface) to be injected
		 * @param mediatorClass The <code>IMediator</code> Class
		 * @param autoCreate Automatically construct and register an instance of Class <code>mediatorClass</code> when an instance of Class <code>moduleClassName</code> is detected
		 * @param autoRemove Automatically remove an instance of Class <code>mediatorClass</code> when it's <code>viewClass</code> leaves the ancestory of the context view
		 */
		function mapModule(moduleClassName:String, localModuleClass:Class, mediatorClass:Class, autoCreate:Boolean = true, autoRemove:Boolean = true):void
		
		/**
		 * Create an instance of a mapped <code>IMediator</code>
		 *
		 * This will create a Mediator for a given View Component.
		 * Mediator dependencies will be automatically resolved.
		 *
		 * @param viewComponent An instance of the view Class previously mapped to an <code>IMediator</code> Class
		 * @return The <code>IMediator</code>
		 */
		function createMediator(viewComponent:Object):IMediator;
		
		/**
		 * Manually register an <code>IMediator</code> instance
		 *
		 * Registering a Mediator will NOT inject it's dependencies.
		 * It is assumed that dependencies are already satisfied.
		 *
		 * @param viewComponent The view component for the <code>IMediator</code>
		 * @param mediator The <code>IMediator</code> to register
		 */
		function registerMediator(viewComponent:Object, mediator:IMediator):void;
		
		/**
		 * Remove a registered <code>IMediator</code> instance
		 *
		 * @param mediator The <code>IMediator</code> to remove
		 * @return The <code>IMediator</code> that was removed
		 */
		function removeMediator(mediator:IMediator):IMediator;
		
		/**
		 * Remove a registered <code>IMediator</code> instance
		 *
		 * @param viewComponent The view that the <code>IMediator</code> was registered with
		 * @return The <code>IMediator</code> that was removed
		 */
		function removeMediatorByView(viewComponent:Object):IMediator;
		
		/**
		 * Retrieve a registered <code>IMediator</code> instance
		 *
		 * @param viewComponent The view that the <code>IMediator</code> was registered with
		 * @return The <code>IMediator</code>
		 */
		function retrieveMediator(viewComponent:Object):IMediator;
		
		/**
		 * Check if the <code>IMediator</code> has been registered
		 *
		 * @param mediator The <code>IMediator</code> instance
		 * @return Whether this <code>IMediator</code> has been registered
		 */
		function hasMediator(mediator:IMediator):Boolean;
		
		/**
		 * Check if an <code>IMediator</code> has been registered for a view instance
		 *
		 * @param viewComponent The view that the <code>IMediator</code> was registered with
		 * @return Whether an <code>IMediator</code> has been registered for this view instance
		 */
		function hasMediatorForView(viewComponent:Object):Boolean;
	
	}
}