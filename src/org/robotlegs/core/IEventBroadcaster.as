package org.robotlegs.core
{
	import flash.events.Event;

	/**
	 * The interface definition for a RobotLegs EventBroadcaster
	 */
	public interface IEventBroadcaster
	{
		/**
		 * Dispatch an <code>Event</code>
		 * @param event The <code>Event</code>
		 * @return Whether the <code>Event</code> was dispatched
		 */
		function dispatchEvent( event:Event ):Boolean;
	}
}