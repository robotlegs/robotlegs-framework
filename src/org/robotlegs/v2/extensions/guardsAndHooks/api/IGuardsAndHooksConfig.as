//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.guardsAndHooks.api
{

	public interface IGuardsAndHooksConfig
	{

		function get guards():Vector.<Class>;

		function get hooks():Vector.<Class>;

		function withGuards(... guardClasses):IGuardsAndHooksConfig;

		function withHooks(... hookClasses):IGuardsAndHooksConfig;
	}
}

