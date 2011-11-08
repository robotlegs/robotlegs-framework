//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.guardsAndHooks.api
{

	[Deprecated(message="any class, method or property with the word AND in it is banned :)")]
	public interface IGuardsAndHooksConfig
	{

		[Deprecated(message="we shouldn't expose things like vectors")]
		function get guards():Vector.<Class>;

		[Deprecated(message="we shouldn't expose things like vectors")]
		function get hooks():Vector.<Class>;

		[Deprecated(message="implementing this interface messes breaks fluent client apis.")]
		function withGuards(... guardClasses):IGuardsAndHooksConfig;

		[Deprecated(message="implementing this interface messes breaks fluent client apis.")]
		function withHooks(... hookClasses):IGuardsAndHooksConfig;
	}
}

