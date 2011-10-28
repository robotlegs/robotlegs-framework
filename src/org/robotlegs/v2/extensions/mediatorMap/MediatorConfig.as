package org.robotlegs.v2.extensions.mediatorMap
{
	import org.robotlegs.v2.extensions.hooks.GuardsAndHooksConfig;

	public class MediatorConfig extends GuardsAndHooksConfig implements IMediatorConfig
	{
	
		public function MediatorConfig(mapping:IMediatorMapping)
		{
			_mapping = mapping;
		}
		
		protected var _mapping:IMediatorMapping;

		public function get mapping():IMediatorMapping
		{
			return _mapping;
		}
	
	}

}