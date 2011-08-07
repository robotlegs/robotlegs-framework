package org.robotlegs.v2.viewmanager 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	public interface IContainerViewFinder 
	{
		function findParentBindingFor(targetObject:DisplayObject):IContainerViewBinding;

		function getContainerViewBindingFor(containerView:DisplayObjectContainer):IContainerViewBinding;
		
		function includeContainer(containerView:DisplayObjectContainer):IContainerViewBinding;
		
		function excludeContainer(containerView:DisplayObjectContainer):IContainerViewBinding; 
	}
}