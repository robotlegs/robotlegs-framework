//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.modularity.dsl
{

	/**
	 * @private
	 */
	public interface IModuleConnectionAction
	{

		function relayEvent(eventType:String):IModuleConnectionAction;

		function receiveEvent(eventType:String):IModuleConnectionAction;

		function suspend():void;

		function resume():void;
	}
}
