package org.robotlegs.v2.viewmanager 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public interface IContainerTreeCreeper
	{
		function findParentBindingFor(targetObject:DisplayObject):IContainerBinding;

		function getContainerBindingFor(container:DisplayObjectContainer):IContainerBinding;
		
		function includeContainer(container:DisplayObjectContainer):IContainerBinding;
		
		function excludeContainer(container:DisplayObjectContainer):IContainerBinding;
		
		function get rootContainerBindings():Vector.<IContainerBinding>; 
	}
}