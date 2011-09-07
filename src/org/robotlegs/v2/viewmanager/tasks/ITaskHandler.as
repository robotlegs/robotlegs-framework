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