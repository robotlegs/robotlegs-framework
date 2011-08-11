package org.robotlegs.v2.viewmanager.tasks
{
	public class TaskHandler
	{                          
		protected var _taskType:Class;
		protected var _handler:Function;
		
		public function TaskHandler(taskType:Class, handler:Function)
		{
			_taskType = taskType;
			_handler = handler;
		}   
		
		public function get taskType():Class
		{
			return _taskType;
		}                    
		
		public function get handler():Function
		{
			return _handler;
		}
	}
}

