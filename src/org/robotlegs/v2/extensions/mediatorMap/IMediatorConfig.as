package org.robotlegs.v2.extensions.mediatorMap
{
	import org.robotlegs.v2.extensions.hooks.IGuardsAndHooksConfig;

	public interface IMediatorConfig extends IGuardsAndHooksConfig
	{

		function get mapping():IMediatorMapping;
	
	}

}