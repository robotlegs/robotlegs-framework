package org.robotlegs.v2.viewmanager.listeningstrategies 
{
	import flash.display.DisplayObjectContainer;

	import org.robotlegs.v2.viewmanager.IListeningStrategy;

	public class ManualViewListeningStrategy extends ViewListeningStrategy implements IListeningStrategy
	{		
		public function ManualViewListeningStrategy(targets:Vector.<DisplayObjectContainer>)
		{
			super(targets);
		}
		
		public function updateTargets(value:Vector.<DisplayObjectContainer>):Boolean
		{
			// do nothing and always return false, as we don't accept change around here!
			return false;
		}
	}
}