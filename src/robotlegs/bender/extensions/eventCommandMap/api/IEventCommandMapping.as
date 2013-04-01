//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventCommandMap.api
{
	import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;

	public interface IEventCommandMapping extends ICommandMapping
	{
		function get priority():int;

		function setPriority(priority:int):ICommandMapping;
	}
}
