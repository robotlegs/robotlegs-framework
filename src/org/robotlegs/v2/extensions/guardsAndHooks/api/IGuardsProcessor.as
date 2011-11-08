//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.guardsAndHooks.api
{
	import org.swiftsuspenders.Injector;

	[Deprecated(message="we shouldn't expose things like vectors")]
	public interface IGuardsProcessor
	{

		function processGuards(useInjector:Injector, guardClasses:Vector.<Class>):Boolean;
	}
}