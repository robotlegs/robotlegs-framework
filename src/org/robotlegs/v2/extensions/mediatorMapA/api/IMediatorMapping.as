//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMapA.api
{
	import org.robotlegs.v2.core.api.ITypeMatcher;
	import org.robotlegs.v2.extensions.mediatorMapA.api.IMediatorConfig;

	public interface IMediatorMapping
	{
		function get mediator():Class;

		function toMatcher(typeMatcher:ITypeMatcher):IMediatorConfig;

		function toView(viewType:Class):IMediatorConfig;
	}
}