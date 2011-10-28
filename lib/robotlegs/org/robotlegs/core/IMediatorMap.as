/*
 * Copyright (c) 2009 the original author or authors
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package org.robotlegs.core
{
	import flash.display.DisplayObjectContainer;
	
	/**
	 * The Robotlegs MediatorMap contract
	 */
	public interface IMediatorMap
	{
		
		/**
		 * Map an <code>IMediator</code> to a view Class
		 *
		 * @param viewClassOrName The concrete view Class or Fully Qualified Class Name
		 * @param mediatorClass The <code>IMediator</code> Class
		 * @param injectViewAs The explicit view Interface or Class that the mediator depends on OR an Array of such Interfaces/Classes.
		 * @param autoCreate Automatically construct and register an instance of Class <code>mediatorClass</code> when an instance of Class <code>viewClass</code> is detected
		 * @param autoRemove Automatically remove an instance of Class <code>mediatorClass</code> when its <code>viewClass</code> leaves the ancestory of the context view
		 */
		function mapView(viewClassOrName:*, mediatorClass:Class, injectViewAs:* = null, autoCreate:Boolean = true, autoRemove:Boolean = true):void;
		
		/**
		 * Unmap a view Class
		 *  
		 * @param viewClassOrName The concrete view Class or Fully Qualified Class Name
		 */		
		function unmapView(viewClassOrName:*):void;
		
		/**
		 * Create an instance of a mapped <code>IMediator</code>
		 *
		 * <p>This will instantiate and register a Mediator for a given View Component.
		 * Mediator dependencies will be automatically resolved.</p>
		 *
		 * @param viewComponent An instance of the view Class previously mapped to an <code>IMediator</code> Class
		 * @return The <code>IMediator</code>
		 */
		function createMediator(viewComponent:Object):IMediator;
		
		/**
		 * Manually register an <code>IMediator</code> instance
		 *
		 * <p>NOTE: Registering a Mediator will NOT inject its dependencies.
		 * It is assumed that dependencies are already satisfied.</p>
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
		 * Check if the view Class has been mapped or not
		 * 
		 * @param viewClassOrName The concrete view Class or Fully Qualified Class Name
		 * 
		 * @return Whether this view class has been mapped
		 */
		function hasMapping(viewClassOrName:*):Boolean;
		
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
		
		/**
		 * The <code>IMediatorMap</code>'s <code>DisplayObjectContainer</code>
		 *
		 * @return view The <code>DisplayObjectContainer</code> to use as scope for this <code>IMediatorMap</code>
		 */
		function get contextView():DisplayObjectContainer;
		
		/**
		 * The <code>IMediatorMap</code>'s <code>DisplayObjectContainer</code>
		 *
		 * @param value The <code>DisplayObjectContainer</code> to use as scope for this <code>IMediatorMap</code>
		 */
		function set contextView(value:DisplayObjectContainer):void;
		
		/**
		 * The <code>IMediatorMap</code>'s enabled status
		 * 
		 * @return Whether the <code>IMediatorMap</code> is enabled
		 */		
		function get enabled():Boolean;
		
		/**
		 * The <code>IMediatorMap</code>'s enabled status
		 * 
		 * @param value Whether the <code>IMediatorMap</code> should be enabled
		 */		
		function set enabled(value:Boolean):void;
	
	}
}