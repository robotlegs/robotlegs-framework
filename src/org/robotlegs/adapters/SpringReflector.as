package org.robotlegs.adapters
{
	import flash.system.ApplicationDomain;
	
	import org.as3commons.lang.ClassUtils;
	import org.as3commons.lang.ObjectUtils;
	import org.robotlegs.core.IReflector;
	
	public class SpringReflector implements IReflector
	{
		public function SpringReflector()
		{
		}
		
		public function classExtendsOrImplements(classOrClassName:Object, superclass:Class, applicationDomain:ApplicationDomain = null):Boolean
		{
			var clazz:Class = (classOrClassName is Class) ? classOrClassName as Class : ClassUtils.forInstance(classOrClassName, applicationDomain);
			return ClassUtils.isAssignableFrom(superclass, clazz);
		}
		
		public function getClass(value:*, applicationDomain:ApplicationDomain = null):Class
		{
			return ClassUtils.forInstance(value, applicationDomain);
		}
		
		public function getFQCN(value:*, replaceColons:Boolean = false):String
		{
			if (value is Class)
			{
				return ClassUtils.getFullyQualifiedName(value, replaceColons);
			}
			else if (value is String)
			{
				return value;
			}
			return ObjectUtils.getFullyQualifiedClassName(value, replaceColons);
		}
	
	}
}