package org.robotlegs.v2.viewmanager.listeningstrategies 
{
	import flash.display.DisplayObjectContainer;
	import org.robotlegs.v2.viewmanager.IListeningStrategy;
	
	public class StageViewListeningStrategy extends ViewListeningStrategy implements IListeningStrategy 
	{
		public function StageViewListeningStrategy(targets:Vector.<DisplayObjectContainer>)
		{
			super(targets);
		}

		public function updateTargets(value:Vector.<DisplayObjectContainer>):Boolean
		{
			if(!_targets && value && value.length>0)
			{
				_targets = new <DisplayObjectContainer>[value[0].stage];
				return true;
			}                           
			else if (_targets && (!value || value.length == 0))
			{
				_targets = null;
				return true;
			}
			return false;
		}
		 
	}
}