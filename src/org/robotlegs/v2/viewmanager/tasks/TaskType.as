package org.robotlegs.v2.viewmanager.tasks 
{
	public class TaskType 
	{                    
		protected var _type:String;
		
		public function TaskType(type:String) 
		{ 
			_type = type;
		}  
		
		public function get type():String
		{
			return _type;
		}
	}
}
