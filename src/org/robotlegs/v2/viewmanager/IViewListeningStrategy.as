package org.robotlegs.v2.viewmanager 
{
	import flash.display.DisplayObjectContainer;
	
	public interface IViewListeningStrategy 
	{
		function get targets():Vector.<DisplayObjectContainer>;
	
		function updateTargets(value:Vector.<DisplayObjectContainer>):Boolean;
		
	}
}