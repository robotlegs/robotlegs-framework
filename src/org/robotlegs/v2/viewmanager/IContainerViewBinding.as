package org.robotlegs.v2.viewmanager 
{
	import flash.display.DisplayObjectContainer;
	
	public interface IContainerViewBinding 
	{
		function get parent():IContainerViewBinding;   
		
		function set parent(value:IContainerViewBinding):void;
		
		function get containerView():DisplayObjectContainer;
		
		function remove():IContainerViewBinding;
	}
}