package org.robotlegs.core
{
	import flash.system.ApplicationDomain;
	
	public interface IReflector
	{
		function classExtendsOrImplements(classOrClassName:Object, superclass:Class, applicationDomain:ApplicationDomain = null):Boolean;
		function getClass(value:*, applicationDomain:ApplicationDomain = null):Class
		function getFQCN(value:*, replaceColons:Boolean = false):String;
	}
}