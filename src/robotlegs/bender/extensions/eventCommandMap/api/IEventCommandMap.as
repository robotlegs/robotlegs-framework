//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventCommandMap.api
{
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;

	public interface IEventCommandMap
	{
		function map(type:String, eventClass:Class = null):ICommandMapper;

		function unmap(type:String, eventClass:Class = null):ICommandUnmapper;
	}
}
