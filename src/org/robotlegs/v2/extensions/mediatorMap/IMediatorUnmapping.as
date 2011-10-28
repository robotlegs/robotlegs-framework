package org.robotlegs.v2.extensions.mediatorMap
{
	import org.robotlegs.v2.core.api.ITypeMatcher;

	public interface IMediatorUnmapping
	{
		function fromView(viewClazz:Class):void;
	
		function fromMatcher(typeMatcher:ITypeMatcher):void;
	}

}