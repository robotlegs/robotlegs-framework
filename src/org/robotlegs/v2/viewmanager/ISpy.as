package org.robotlegs.v2.viewmanager
{
	import flash.display.DisplayObjectContainer;

	import org.robotlegs.v2.viewmanager.tasks.ITaskHandler;

	public interface ISpy
	{
		function addInterest(target:DisplayObjectContainer, taskHandler:ITaskHandler):void;
		
		function removeInterest(target:DisplayObjectContainer, taskHandler:ITaskHandler):void;

		function get listeningStrategy():IListeningStrategy;
		function set listeningStrategy(strategy:IListeningStrategy):void;
	}

}