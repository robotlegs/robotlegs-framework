package net.boyblack.robotlegs.core
{
	import flash.events.Event;
	
	public interface IEventBroadcaster
	{
		function dispatchEvent( event:Event ):Boolean;
	}
}