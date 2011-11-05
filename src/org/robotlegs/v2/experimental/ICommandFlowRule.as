//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.experimental
{
	import org.robotlegs.v2.extensions.guardsAndHooks.api.IGuardsAndHooksConfig;
	import flash.events.Event;

	public interface ICommandFlowRule
	{		
		function applyEvent(event:Event):Boolean;
		
		function get commandClasses():Vector.<Class>;
		
		function get receivedEvents():Vector.<Event>;
	}
}