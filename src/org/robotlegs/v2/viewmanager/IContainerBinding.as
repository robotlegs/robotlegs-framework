package org.robotlegs.v2.viewmanager 
{
	import flash.display.DisplayObjectContainer;
	
	public interface IContainerBinding 
	{
		function get parent():IContainerBinding;   
		
		function set parent(value:IContainerBinding):void;
		
		function get container():DisplayObjectContainer;
		
		function remove():IContainerBinding;
  	}
}