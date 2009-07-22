package org.robotlegs.core
{
	
	public interface IInjector
	{
		function bindValue(whenAskedFor:Class, useValue:Object, named:String = null):void;
		function bindClass(whenAskedFor:Class, instantiateClass:Class, named:String = null):void;
		function bindSingleton(whenAskedFor:Class, named:String = null):void;
		function bindSingletonOf(whenAskedFor:Class, useSingletonOf:Class, named:String = null):void;
		function injectInto(target:Object):void;
		function unbind(clazz:Class, named:String = null):void;
	}
}