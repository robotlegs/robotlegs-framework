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
	 * The Robotlegs ViewMap contract
	 */
	public interface IViewMap
	{
		/**
		 * Map a view component Class for automatic injection
		 *
		 * @param viewClassOrName The concrete view Class or Fully Qualified Class Name
		 */
		function mapClass(viewClassOrName:*):void;
		
		/**
		 * Map an entire package (including sub-packages) for automatic injection
		 * 
		 * @param packageName The substring to compare
		 */		
		function mapPackage(packageName:String):void;
		
		/**
		 * Unmap a view component Class
		 *
		 * @param viewClassOrName The concrete view Class or Fully Qualified Class Name
		 */
		function unmapClass(viewClassOrName:*):void;
		
		/**
		 * Unmap a package
		 * 
		 * @param packageName The substring to compare
		 */		
		function unmapPackage(packageName:String):void;
		
		/**
		 * Check if a Class has been registered for automatic injection
		 *
		 * @param viewClassOrName The concrete view Class or Fully Qualified Class Name
		 * @return Whether a Class has been registered for automatic injection
		 */
		function hasClass(viewClassOrName:*):Boolean;
		
		/**
		 * Map a view component interface for automatic injection
		 *
		 * @param type The concrete view Interface
		 */
		function mapInterface(type:Class):void;
		
		/**
		 * Unmap a view component interface
		 *
		 * @param type The concrete view Interface
		 */
		function unmapInterface(type:Class):void;
		
		/**
		 * Check if a interface has been registered for automatic injection
		 *
		 * @param type The concrete view interface 
		 * @return Whether an interface has been registered for automatic injection
		 */
		function hasInterface(type:Class):Boolean;
		
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