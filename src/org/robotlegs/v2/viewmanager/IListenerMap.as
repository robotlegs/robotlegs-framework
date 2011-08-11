package org.robotlegs.v2.viewmanager
{
	import flash.events.IEventDispatcher;

	public interface IListenerMap
	{

		function updateListenerTargets(targets:Vector.<IEventDispatcher>):void;
	
	}

}