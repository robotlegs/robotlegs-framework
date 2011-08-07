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
	 * The Robotlegs ViewMap contract. All IViewMap automatic injections occur AFTER the view components are added to the stage.
	 */
	public interface IViewMap
	{
		/**
		 * Map an entire package (including sub-packages) for automatic injection
		 * 
		 * @param packageName The substring to compare
		 */		
		function mapPackage(packageName:String):void;
		
		/**
		 * Unmap a package
		 * 
		 * @param packageName The substring to compare
		 */		
		function unmapPackage(packageName:String):void;
		
		/**
		 * Check if a package has been registered for automatic injection
		 *
		 * @param packageName The substring to compare
		 * @return Whether a package has been registered for automatic injection
		 */
		function hasPackage(packageName:String):Boolean;
		
		/**
		 * Map a view component class or interface for automatic injection
		 *
		 * @param type The concrete view Interface
		 */
		function mapType(type:Class):void;
		
		/**
		 * Unmap a view component class or interface
		 *
		 * @param type The concrete view Interface
		 */
		function unmapType(type:Class):void;
		
		/**
		 * Check if a class or interface has been registered for automatic injection
		 *
		 * @param type The concrete view interface 
		 * @return Whether an interface has been registered for automatic injection
		 */
		function hasType(type:Class):Boolean;
		
		/**
		 * The <code>IViewMap</code>'s <code>DisplayObjectContainer</code>
		 *
		 * @return view The <code>DisplayObjectContainer</code> to use as scope for this <code>IViewMap</code>
		 */
		function get contextView():DisplayObjectContainer;
		
		/**
		 * The <code>IViewMap</code>'s <code>DisplayObjectContainer</code>
		 *
		 * @param value The <code>DisplayObjectContainer</code> to use as scope for this <code>IViewMap</code>
		 */
		function set contextView(value:DisplayObjectContainer):void;
		
		/**
		 * The <code>IViewMap</code>'s enabled status
		 *
		 * @return Whether the <code>IViewMap</code> is enabled
		 */
		function get enabled():Boolean;
		
		/**
		 * The <code>IViewMap</code>'s enabled status
		 *
		 * @param value Whether the <code>IViewMap</code> should be enabled
		 */
		function set enabled(value:Boolean):void;
	
	}
}