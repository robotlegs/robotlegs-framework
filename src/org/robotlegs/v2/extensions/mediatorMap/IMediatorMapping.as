package org.robotlegs.v2.extensions.mediatorMap
{
	import org.robotlegs.v2.extensions.hooks.IGuardsAndHooksConfig;
	import org.robotlegs.v2.core.api.ITypeMatcher;
	
	public interface IMediatorMapping extends IGuardsAndHooksConfig
	{
		function get mediatorClass():Class;
				
		function get viewClass():Class;
		
		function toView(viewClazz:Class):IGuardsAndHooksConfig;
		
		function toMatcher(typeMatcher:ITypeMatcher):IGuardsAndHooksConfig;
	}
}