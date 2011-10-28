package org.robotlegs.v2.extensions.mediatorMap
{
	import org.robotlegs.v2.extensions.hooks.IGuardsAndHooksConfig;
	import org.robotlegs.v2.core.api.ITypeMatcher;
	
	public interface IMediatorMapping extends IGuardsAndHooksConfig
	{
		function get mediator():Class;
				
		function toView(viewClazz:Class):IGuardsAndHooksConfig;
		
		function toMatcher(typeMatcher:ITypeMatcher):IGuardsAndHooksConfig;
		
		function unmap(typeMatcher:ITypeMatcher):void;
	}
}