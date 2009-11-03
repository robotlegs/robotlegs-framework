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
	 * The Robotlegs Injector contract
	 */
	public interface IInjector
	{
		/**
		 * When asked for an instance of the class <code>whenAskedFor</code>
		 * inject the instance <code>useValue</code>.
		 *
		 * <p>This is used to register an existing instance with the injector
		 * and treat it like a Singleton.</p>
		 *
		 * @param whenAskedFor A class or interface
		 * @param useValue An instance
		 * @param named An optional name (id)
		 */
		function mapValue(whenAskedFor:Class, useValue:Object, named:String = ""):void;
		
		/**
		 * When asked for an instance of the class <code>whenAskedFor</code>
		 * inject a new instance of <code>instantiateClass</code>.
		 *
		 * <p>This will create a new instance for each injection.</p>
		 *
		 * @param whenAskedFor A class or interface
		 * @param instantiateClass A class to instantiate
		 * @param named An optional name (id)
		 */
		function mapClass(whenAskedFor:Class, instantiateClass:Class, named:String = ""):void;
		
		/**
		 * When asked for an instance of the class <code>whenAskedFor</code>
		 * inject an instance of <code>whenAskedFor</code>.
		 *
		 * <p>This will create an instance on the first injection, but
		 * will re-use that instance for subsequent injections.</p>
		 *
		 * @param whenAskedFor A class or interface
		 * @param named An optional name (id)
		 */
		function mapSingleton(whenAskedFor:Class, named:String = ""):void;
		
		
		/**
		 * When asked for an instance of the class <code>whenAskedFor</code>
		 * inject an instance of <code>useSingletonOf</code>.
		 *
		 * <p>This will create an instance on the first injection, but
		 * will re-use that instance for subsequent injections.</p>
		 *
		 * @param whenAskedFor A class or interface
		 * @param useSingletonOf A class to instantiate
		 * @param named An optional name (id)
		 */
		function mapSingletonOf(whenAskedFor:Class, useSingletonOf:Class, named:String = ""):void;
		
		/**
		 * Perform an injection into an object, satisfying all it's dependencies
		 *
		 * <p>The <code>IInjector</code> should throw an <code>Error</code>
		 * if it can't satisfy all dependencies of the injectee.</p>
		 *
		 * @param target The object to inject into - the Injectee
		 */
		function injectInto(target:Object):void;
		
		/**
		 * Create an object of the given class, supplying its dependencies as constructor parameters
		 * if the used DI solution has support for constructor injection
		 *
		 * <p>Adapters for DI solutions that don't support constructor injection should just create a new
		 * instance and perform setter and/ or method injection on that.</p>
		 *
		 * <p>The <code>IInjector</code> should throw an <code>Error</code>
		 * if it can't satisfy all dependencies of the injectee.</p>
		 *
		 * @param target The class to instantiate
		 * @return the created instance
		 */
		function instantiate(clazz:Class):*;
		
		/**
		 * Remove a rule from the injector
		 *
		 * @param clazz A class or interface
		 * @param named An optional name (id)
		 */
		function unmap(clazz:Class, named:String = ""):void;
	}
}
