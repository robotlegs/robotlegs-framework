package org.robotlegs.v2.viewmanager 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	public class ContainerViewFinder implements IContainerViewFinder 
	{
		protected var _bindingsByContainer:Dictionary;
		
		public function ContainerViewFinder() 
		{
			_bindingsByContainer = new Dictionary();
		}
		
		public function findParentBindingFor(targetObject:DisplayObject):IContainerViewBinding
		{         
			var checkParent:DisplayObjectContainer = targetObject.parent;
        	while(checkParent)
			{                                              
				if(_bindingsByContainer[checkParent])
				{
					return _bindingsByContainer[checkParent];
				}
				checkParent = checkParent.parent;
			}
			return null;
		}
		
		public function getContainerViewBindingFor(containerView:DisplayObjectContainer):IContainerViewBinding
		{
        	return _bindingsByContainer[containerView];
		}

		public function includeContainer(containerView:DisplayObjectContainer):IContainerViewBinding
		{            
			return _bindingsByContainer[containerView] ||= createBindingFor(containerView);
		}   

		public function excludeContainer(containerView:DisplayObjectContainer):IContainerViewBinding
		{                          
			if(!_bindingsByContainer[containerView])
				return null;
			return removeBindingFor(containerView);
		}    

		protected function createBindingFor(containerView:DisplayObjectContainer):IContainerViewBinding
		{
			const binding:IContainerViewBinding = new ContainerViewBinding(containerView, removeBinding);
			binding.parent = findParentBindingFor(containerView);
			addToChildBindings(binding, containerView);
			return binding;
		}
		
		protected function removeBindingFor(containerView:DisplayObjectContainer):IContainerViewBinding
		{
			const binding:IContainerViewBinding = _bindingsByContainer[containerView];
		    delete _bindingsByContainer[containerView];
			removeFromChildBindings(binding);
        	return binding;
		}
		
		protected function addToChildBindings(binding:IContainerViewBinding, containerView:DisplayObjectContainer):void
		{        
			var childView:Object;
			for (childView in _bindingsByContainer)
			{
				if(containerView.contains(childView as DisplayObject) && 
					(   (! _bindingsByContainer[childView].parent) ||
						(! containerView.contains(_bindingsByContainer[childView].parent.containerView))	) 	)
				{
					_bindingsByContainer[childView].parent = binding;
				}
			}
		}
		
		protected function removeFromChildBindings(binding:IContainerViewBinding):void
		{                         
			var childBinding:IContainerViewBinding;
			for each (childBinding in _bindingsByContainer)
			{
				if(childBinding.parent == binding)
				{
					childBinding.parent = binding.parent;
				}
			}
		}
		
		protected function removeBinding(binding:IContainerViewBinding):void
		{
			excludeContainer(binding.containerView);
		}
	}
}