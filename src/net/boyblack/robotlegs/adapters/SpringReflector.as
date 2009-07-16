package net.boyblack.robotlegs.adapters
{
	import net.boyblack.robotlegs.core.IReflector;
	
	import org.as3commons.lang.ClassUtils;

	public class SpringReflector implements IReflector
	{
		public function SpringReflector()
		{
		}

		public function classExtendsOrImplements( classOrClassName:Object, superclass:Class ):Boolean
		{
			var clazz:Class = ( classOrClassName is Class ) ? classOrClassName as Class : ClassUtils.forInstance( classOrClassName );
			return ClassUtils.isAssignableFrom( superclass, clazz );
		}

		public function getClass( object:Object ):Class
		{
			return ClassUtils.forInstance( object );
		}

	}
}