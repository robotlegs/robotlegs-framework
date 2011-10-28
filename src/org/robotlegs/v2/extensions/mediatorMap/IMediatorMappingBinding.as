package org.robotlegs.v2.extensions.mediatorMap
{
	import org.robotlegs.v2.extensions.hooks.IGuardsAndHooksMapBinding;
	import org.robotlegs.v2.core.api.ITypeMatcher;
	
	public interface IMediatorMappingBinding extends IGuardsAndHooksMapBinding
	{
		function get mediatorClass():Class;
				
		function get viewClass():Class;
		
		function toView(viewClazz:Class):IGuardsAndHooksMapBinding;
		
		function toMatcher(typeMatcher:ITypeMatcher):IGuardsAndHooksMapBinding;
	}
}