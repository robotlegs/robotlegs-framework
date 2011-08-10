package org.robotlegs.v2.viewmanager.listeningstrategies 
{
	import flash.display.DisplayObjectContainer;
	import org.robotlegs.v2.viewmanager.IViewListeningStrategy;
	
	public class StageViewListeningStrategy implements IViewListeningStrategy 
	{
		protected var _stageVector:Vector.<DisplayObjectContainer>;
	
		public function get targets():Vector.<DisplayObjectContainer>
		{
			 return _stageVector || new Vector.<DisplayObjectContainer>();
		}

		public function updateTargets(value:Vector.<DisplayObjectContainer>):Boolean
		{
			if(!_stageVector && value && value.length>0)
			{
				_stageVector = new <DisplayObjectContainer>[value[0].stage];
				return true;
			}                           
			else if (_stageVector && (!value || value.length == 0))
			{
				_stageVector = null;
				return true;
			}
			return false;
		}
		 
	}
}