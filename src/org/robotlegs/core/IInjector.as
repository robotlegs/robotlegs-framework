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
		 * @param whenAskedFor A class
		 * @param useValue An instance
		 * @param named An optional name (id)
		 */		
		function bindValue(whenAskedFor:Class, useValue:Object, named:String = null):void;
		
		/**
		 * When asked for an instance of the class <code>whenAskedFor</code>
		 * inject a new instance of <code>instantiateClass</code>.
		 * 
		 * @param whenAskedFor A class
		 * @param instantiateClass A class to instantiate
		 * @param named An optional name (id)
		 */		
		function bindClass(whenAskedFor:Class, instantiateClass:Class, named:String = null):void;
		
		function bindSingleton(whenAskedFor:Class, named:String = null):void;
		
		function bindSingletonOf(whenAskedFor:Class, useSingletonOf:Class, named:String = null):void;
		
		/**
		 * Perform an injection into an object, satisfying all it's dependencies
		 * @param target The object to inject into
		 */		
		function injectInto(target:Object):void;
		
		function unbind(clazz:Class, named:String = null):void;
	}
}