//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.context.api
{
	import org.swiftsuspenders.v2.dsl.IInjector;

	public interface IContext
	{
		function get injector():IInjector;
	}
}
