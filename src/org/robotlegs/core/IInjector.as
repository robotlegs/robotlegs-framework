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
	 * The interface definition for a RobotLegs Injector
	 */
	public interface IInjector
	{
		/**
		 * When asked for an instance of the class <code>whenAskedFor</code>
		 * inject the instance <code>useValue</code>.
		 *
		 * This is used to register an existing instance with the injector
		 * and treat it like a Singleton.
		 *
		 * @param whenAskedFor A class or interface
		 * @param useValue An instance
		 * @param named An optional name (id)
		 */
		function bindValue(whenAskedFor:Class, useValue:Object, named:String = null):void;
		
		/**
		 * When asked for an instance of the class <code>whenAskedFor</code>
		 * inject a new instance of <code>instantiateClass</code>.
		 *
		 * This will create a new instance for each injection.
		 *
		 * @param whenAskedFor A class or interface
		 * @param instantiateClass A class to instantiate
		 * @param named An optional name (id)
		 */
		function bindClass(whenAskedFor:Class, instantiateClass:Class, named:String = null):void;
		
		/**
		 * When asked for an instance of the class <code>whenAskedFor</code>
		 * inject an instance of code>whenAskedFor</code>.
		 *
		 * This will create an instance on the first injection, but
		 * will re-use that instance for subsequent injections.
		 *
		 * @param whenAskedFor A class or interface
		 * @param named An optional name (id)
		 */
		function bindSingleton(whenAskedFor:Class, named:String = null):void;
		
		
		/**
		 * When asked for an instance of the class <code>whenAskedFor</code>
		 * inject an instance of code>useSingletonOf</code>.
		 *
		 * This will create an instance on the first injection, but
		 * will re-use that instance for subsequent injections.
		 *
		 * @param whenAskedFor A class or interface
		 * @param useSingletonOf A class to instantiate
		 * @param named An optional name (id)
		 */
		function bindSingletonOf(whenAskedFor:Class, useSingletonOf:Class, named:String = null):void;
		
		/**
		 * Perform an injection into an object, satisfying all it's dependencies
		 *
		 * The <code>IInjector</code> should throw an <code>Error</code>
		 * if it can't satisfy all dependencies of the injectee.
		 *
		 * @param target The object to inject into - the Injectee
		 */
		function injectInto(target:Object):void;
		
		/**
		 * Remove a rule from the injector
		 *
		 * @param clazz A class or interface
		 * @param named An optional name (id)
		 */
		function unbind(clazz:Class, named:String = null):void;
	}
}