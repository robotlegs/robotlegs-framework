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
		 * 
		 * @return * A reference to the rule for this injection. To be used with <code>mapRule</code>
		 */
		function mapValue(whenAskedFor:Class, useValue:Object, named:String = ""):*;
		
		/**
		 * When asked for an instance of the class <code>whenAskedFor</code>
		 * inject a new instance of <code>instantiateClass</code>.
		 *
		 * <p>This will create a new instance for each injection.</p>
		 *
		 * @param whenAskedFor A class or interface
		 * @param instantiateClass A class to instantiate
		 * @param named An optional name (id)
		 * 
		 * @return * A reference to the rule for this injection. To be used with <code>mapRule</code>
		 */
		function mapClass(whenAskedFor:Class, instantiateClass:Class, named:String = ""):*;
		
		/**
		 * When asked for an instance of the class <code>whenAskedFor</code>
		 * inject an instance of <code>whenAskedFor</code>.
		 *
		 * <p>This will create an instance on the first injection, but
		 * will re-use that instance for subsequent injections.</p>
		 *
		 * @param whenAskedFor A class or interface
		 * @param named An optional name (id)
		 * 
		 * @return * A reference to the rule for this injection. To be used with <code>mapRule</code>
		 */
		function mapSingleton(whenAskedFor:Class, named:String = ""):*;
		
		
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
		 * 
		 * @return * A reference to the rule for this injection. To be used with <code>mapRule</code>
		 */
		function mapSingletonOf(whenAskedFor:Class, useSingletonOf:Class, named:String = ""):*;
		
		/**
		 * When asked for an instance of the class <code>whenAskedFor</code>
		 * use rule <code>useRule</code> to determine the correct injection.
		 *
		 * <p>This will use whatever injection is set by the given injection rule as created using 
		 * one of the other mapping methods.</p>
		 *
		 * @param whenAskedFor A class or interface
		 * @param useRule The rule to use for the injection
		 * @param named An optional name (id)
		 * 
		 * @return * A reference to the rule for this injection. To be used with <code>mapRule</code>
		 */
		function mapRule(whenAskedFor:Class, useRule:*, named:String = ""):*;
		
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
		 * <p>NOTE: This method will always create a new instance. If you need to retrieve an instance
		 * consider using <code>getInstance</code></p>
		 *
		 * <p>The <code>IInjector</code> should throw an <code>Error</code>
		 * if it can't satisfy all dependencies of the injectee.</p>
		 *
		 * @param clazz The class to instantiate
		 * @return * The created instance
		 */
		function instantiate(clazz:Class):*;
		
		/**
		 * Create or retrieve an instance of the given class
		 * 
		 * @param clazz
		 * @param named An optional name (id)
		 * @return * An instance
		 */		
		function getInstance(clazz:Class, named:String = ""):*;
		
		/**
		 * Create an injector that inherits rules from its parent
		 * 
		 * @return The injector 
		 */		
		function createChild(applicationDomain:ApplicationDomain = null):IInjector;
		
		/**
		 * Remove a rule from the injector
		 *
		 * @param clazz A class or interface
		 * @param named An optional name (id)
		 */
		function unmap(clazz:Class, named:String = ""):void;
		
		/**
		 * Does a rule exist to satsify such a request?
		 * 
		 * @param clazz A class or interface
		 * @param named An optional name (id)
		 * @return Whether such a mapping exists
		 */		
		function hasMapping(clazz:Class, named:String = ""):Boolean;
		
		/**
		 * @return The Application Domain
		 */		
		function get applicationDomain():ApplicationDomain;
		
		/**
		 * @param value The Application Domain
		 */		
		function set applicationDomain(value:ApplicationDomain):void;
		
	}
}