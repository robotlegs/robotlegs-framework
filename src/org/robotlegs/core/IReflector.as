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
	import flash.system.ApplicationDomain;
	
	/**
	 * The interface definition for a RobotLegs <code>IReflector</code>
	 */
	public interface IReflector
	{
		
		/**
		 * Does this class or class name implement this superclass or interface?
		 * @param classOrClassName
		 * @param superclass
		 * @param applicationDomain
		 * @return Boolean
		 */
		function classExtendsOrImplements(classOrClassName:Object, superclass:Class, applicationDomain:ApplicationDomain = null):Boolean;
		
		/**
		 * Get the class of this instance
		 * @param value The instance
		 * @param applicationDomain
		 * @return Class
		 *
		 */
		function getClass(value:*, applicationDomain:ApplicationDomain = null):Class
		
		/**
		 * Get the Fully Qualified Class Name of this instance, class name, or class
		 * @param value The instance, class name, or class
		 * @param replaceColons
		 * @return The Fully Qualified Class Name
		 */
		function getFQCN(value:*, replaceColons:Boolean = false):String;
	
	}
}