package org.robotlegs.adapters
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import org.robotlegs.core.IReflector;
	import net.expantra.smartypants.utils.Reflection;
	
	public class SmartyPantsReflector implements IReflector
	{
		public function SmartyPantsReflector()
		{
		}
		
		public function classExtendsOrImplements(classOrClassName:Object, superclass:Class):Boolean
		{
			return Reflection.classExtendsOrImplements(classOrClassName, superclass);
		}
		
		public function getClass(object:Object):Class
		{
			return Class(getDefinitionByName(getQualifiedClassName(object)));
		}
	
	}
}