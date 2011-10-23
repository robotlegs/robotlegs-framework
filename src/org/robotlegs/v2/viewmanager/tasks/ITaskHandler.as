//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.viewmanager.tasks
{
	import flash.events.Event;

	public interface ITaskHandler
	{
		function get taskType():Class;

		function addedHandler(e:Event):uint;

		function removedHandler(e:Event):uint;
	}
}
