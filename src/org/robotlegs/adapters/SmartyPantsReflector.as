package org.robotlegs.adapters
{
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import net.expantra.smartypants.utils.Reflection;
	
	import org.robotlegs.core.IReflector;
	
	public class SmartyPantsReflector implements IReflector
	{
		public function SmartyPantsReflector()
		{
		}
		
		public function classExtendsOrImplements(classOrClassName:Object, superclass:Class, application:ApplicationDomain = null):Boolean
		{
			return Reflection.classExtendsOrImplements(classOrClassName, superclass);
		}
		
		public function getClass(value:*, applicationDomain:ApplicationDomain = null):Class
		{
			return Class(getDefinitionByName(getQualifiedClassName(value)));
		}
		
		public function getFQCN(value:*, replaceColons:Boolean = false):String
		{
			return getQualifiedClassName(value).replace('::', '.');
		}
	}
}