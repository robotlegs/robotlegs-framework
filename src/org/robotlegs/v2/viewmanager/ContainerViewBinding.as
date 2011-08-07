package org.robotlegs.v2.viewmanager 
{
	import flash.display.DisplayObjectContainer;
	
	public class ContainerViewBinding implements IContainerViewBinding
	{                
		protected var _containerView:DisplayObjectContainer;
		protected var _parent:IContainerViewBinding;
		protected var _removeHandler:Function;
		
		public function ContainerViewBinding(containerView:DisplayObjectContainer, removeHandler:Function) 
		{ 
			_containerView = containerView;
			_removeHandler = removeHandler;
		}
		
        public function get parent():IContainerViewBinding
        {
        	return _parent;
        }

		public function set parent(value:IContainerViewBinding):void
		{
			_parent = value;
		}

        public function get containerView():DisplayObjectContainer
        {
        	return _containerView;
        }

        public function suspend():IContainerViewBinding
        {
        	return null;
        }

        public function resume():IContainerViewBinding
        {
        	return null;
        }

        public function remove():IContainerViewBinding
        {              
			_removeHandler(this);
        	return this;
        }
	}
}