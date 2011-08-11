package org.robotlegs.v2.viewmanager.listeningstrategies
{
	import flash.display.DisplayObjectContainer;

	public class ViewListeningStrategy
	{
		protected var _targets:Vector.<DisplayObjectContainer>;
		
		public function ViewListeningStrategy(targets:Vector.<DisplayObjectContainer>)
		{
			_targets = targets;
		} 
		
		public function get targets():Vector.<DisplayObjectContainer>
		{
			return _targets || new Vector.<DisplayObjectContainer>();
		}
	}
}