package org.robotlegs.v2.viewmanager
{
	import flash.display.DisplayObjectContainer;

	public interface ISpy
	{
		function addInterestIn(target:DisplayObjectContainer, eventType:String, callback:Function, taskType:Class):void;
		
		function removeInterestIn(target:DisplayObjectContainer, eventType:String, callback:Function, taskType:Class):void;

		function get listeningStrategy():IListeningStrategy;
		function set listeningStrategy(strategy:IListeningStrategy):void;
	}

}