//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap.api
{
	import org.robotlegs.v2.core.api.ITypeMatcher;
	import org.robotlegs.v2.extensions.hooks.IGuardsAndHooksConfig;

	public interface IMediatorMapping extends IGuardsAndHooksConfig
	{
		function get mediator():Class;

		function toMatcher(typeMatcher:ITypeMatcher):IGuardsAndHooksConfig;

		function toView(viewType:Class):IGuardsAndHooksConfig;
	}
}
