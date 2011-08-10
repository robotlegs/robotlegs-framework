package org.robotlegs.v2.viewmanager.listeningstrategies 
{
	import org.robotlegs.v2.viewmanager.IViewListeningStrategy;
	import flash.display.DisplayObjectContainer;
	
	public class FewestEventsViewListeningStrategy implements IViewListeningStrategy
	{
		protected var _targets:Vector.<DisplayObjectContainer>;
	
	   	public function get targets():Vector.<DisplayObjectContainer>
	   	{
			return _targets || new Vector.<DisplayObjectContainer>();
	   	}

	   	public function updateTargets(value:Vector.<DisplayObjectContainer>):Boolean
	   	{      
		    var oldTargets:Vector.<DisplayObjectContainer> = _targets;
			_targets = value;
			
   	    	return areDifferentVectorsIgnoringOrder(_targets, oldTargets);
	   	}
	}
}