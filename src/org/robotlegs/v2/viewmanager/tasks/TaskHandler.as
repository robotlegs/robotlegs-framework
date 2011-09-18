package org.robotlegs.v2.viewmanager.tasks
{
	import flash.events.Event;
	
	public class TaskHandler implements ITaskHandler
	{                          
		protected var _taskType:Class;
		protected var _addedHandler:Function;
		protected var _removedHandler:Function;
		
		public function TaskHandler(taskType:Class, useAddedHandler:Function, useRemovedHandler:Function)
		{
			_taskType = taskType;
			_addedHandler = useAddedHandler;
			_removedHandler = useRemovedHandler;
		}   
		
		public function get taskType():Class
		{
			return _taskType;
		}                    
		
		public function addedHandler(e:Event):uint
		{
			return _addedHandler(e);
		}
		
		public function removedHandler(e:Event):uint
		{
			if ( _removedHandler != null)
			{
				return _removedHandler(e);
			}
			return 0;
		}
	}
}