package org.robotlegs.adapters
{
	import org.robotlegs.core.IInjector;
	import net.expantra.smartypants.Injector;
	import net.expantra.smartypants.SmartyPants;
	import net.expantra.smartypants.dsl.InjectorRuleNamed;

	public class SmartyPantsInjector implements IInjector
	{
		protected var injector:Injector;

		public function SmartyPantsInjector( injector:Injector = null )
		{
			this.injector = injector ? injector : SmartyPants.getOrCreateInjectorFor( this );
		}

		public function bindValue( whenAskedFor:Class, useValue:Object, named:String = null ):void
		{
			getRule( whenAskedFor, named ).useValue( useValue );
		}

		public function bindClass( whenAskedFor:Class, instantiateClass:Class, named:String = null ):void
		{
			getRule( whenAskedFor, named ).useClass( instantiateClass );
		}

		public function bindSingleton( whenAskedFor:Class, named:String = null ):void
		{
			getRule( whenAskedFor, named ).useSingleton();
		}

		public function bindSingletonOf( whenAskedFor:Class, useSingletonOf:Class, named:String = null ):void
		{
			getRule( whenAskedFor, named ).useSingletonOf( useSingletonOf );
		}

		public function injectInto( target:Object ):void
		{
			injector.injectInto( target );
		}

		public function unbind( clazz:Class, named:String = null ):void
		{
			getRule( clazz, named ).defaultBehaviour();
		}

		protected function getRule( clazz:Class, named:String = null ):InjectorRuleNamed
		{
			return named ? injector.newRule().whenAskedFor( clazz ).named( named ) : injector.newRule().whenAskedFor( clazz );
		}

	}
}