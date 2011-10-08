package org.robotlegs.v2.viewmanager.listeningstrategies 
{
	import flash.display.DisplayObjectContainer;

	import org.robotlegs.v2.viewmanager.IListeningStrategy;

	public class FewestEventsViewListeningStrategy extends ViewListeningStrategy implements IListeningStrategy
	{
		public function FewestEventsViewListeningStrategy(targets:Vector.<DisplayObjectContainer>)
		{
		   super(targets);
		}

	   	public function updateTargets(value:Vector.<DisplayObjectContainer>):Boolean
	   	{      
		    var oldTargets:Vector.<DisplayObjectContainer> = _targets;
			_targets = value;
			
   	    	return areDifferentVectorsIgnoringOrder(_targets, oldTargets);
	   	}
	}
}