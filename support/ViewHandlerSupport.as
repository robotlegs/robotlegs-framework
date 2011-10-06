package 
{
	import org.robotlegs.v2.view.api.IViewHandler;

	public class ViewHandlerSupport implements IViewHandler
	{
		protected var _addedHandler:Function;
		protected var _removedHandler:Function;
		protected var _taskID:uint;
		protected var _blocked:Boolean;
		
		protected const TASK_1:uint = 0x000001; 
		protected const TASK_2:uint = 0x000004; 
		protected const TASK_3:uint = 0x000010; 
		protected const TASK_4:uint = 0x000040; 
		protected const TASK_5:uint = 0x000100; 
		protected const TASK_6:uint = 0x000400; 
		protected const TASK_7:uint = 0x001000; 
		protected const TASK_8:uint = 0x004000; 
        
		protected const BLOCK_1:uint = 0x000002; 
		protected const BLOCK_2:uint = 0x000008; 
		protected const BLOCK_3:uint = 0x000020; 
		protected const BLOCK_4:uint = 0x000080; 
		protected const BLOCK_5:uint = 0x000200; 
		protected const BLOCK_6:uint = 0x000800; 
		protected const BLOCK_7:uint = 0x002000; 
		protected const BLOCK_8:uint = 0x008000; 
		
		public function ViewHandlerSupport(taskID:uint, blocked:Boolean, addedHandler:Function, removedHandler:Function = null)
		{
			_taskID = this['TASK_' + taskID];
			
			if(blocked)
			{
				_taskID = _taskID | _this['BLOCK_' + taskID];
			}
			
			_blocked = blocked;
			_addedHandler = addedHandler;
			_removedHandler = removedHandler;
		}
		
		//---------------------------------------
		// IViewHandler Implementation
		//---------------------------------------

		public function get interests():uint
		{
			return _taskID;
		}

		public function handleViewAdded(view:DisplayObject, info:IViewClassInfo):uint
		{
			_addedHandler(view, info);
		}

		public function handleViewRemoved(view:DisplayObject):void
		{
			_removedHandler(view, info);
		}
	}
}