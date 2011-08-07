/*
 * Copyright (c) 2009 the original author or authors
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package org.robotlegs.core
{
	import flash.system.ApplicationDomain;
	
	/**
	 * The Robotlegs Reflector contract
	 */
	public interface IReflector
	{
		
		/**
		 * Does this class or class name implement this superclass or interface?
		 * 
		 * @param classOrClassName
		 * @param superclass
		 * @param applicationDomain
		 * @return Boolean
		 */
		function classExtendsOrImplements(classOrClassName:Object, superclass:Class, applicationDomain:ApplicationDomain = null):Boolean;
		
		/**
		 * Get the class of this instance
		 * 
		 * @param value The instance
		 * @param applicationDomain
		 * @return Class
		 */
		function getClass(value:*, applicationDomain:ApplicationDomain = null):Class
		
		/**
		 * Get the Fully Qualified Class Name of this instance, class name, or class
		 * 
		 * @param value The instance, class name, or class
		 * @param replaceColons
		 * @return The Fully Qualified Class Name
		 */
		function getFQCN(value:*, replaceColons:Boolean = false):String;
	
	}
}