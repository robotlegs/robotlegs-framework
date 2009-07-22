package org.robotlegs.core
{
	
	public interface IReflector
	{
		function classExtendsOrImplements(classOrClassName:Object, superclass:Class):Boolean;
		function getClass(object:Object):Class;
	}
}