package org.robotlegs.v2.viewmanager 
{
	import flash.display.DisplayObjectContainer;

	public class ContainerBinding implements IContainerBinding
	{                
		protected var _container:DisplayObjectContainer;
		protected var _parent:IContainerBinding;
		protected var _removeHandler:Function;
		
		public function ContainerBinding(container:DisplayObjectContainer, removeHandler:Function) 
		{ 
			_container = container;
			_removeHandler = removeHandler;
		}
		
        public function get parent():IContainerBinding
        {
        	return _parent;
        }

		public function set parent(value:IContainerBinding):void
		{
			_parent = value;
		}

        public function get container():DisplayObjectContainer
        {
        	return _container;
        }

        public function remove():IContainerBinding
        {              
			_removeHandler(this);
        	return this;
        }
	}
}