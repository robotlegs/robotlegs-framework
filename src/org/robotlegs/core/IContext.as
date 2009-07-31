package org.robotlegs.core
{
	import flash.events.IEventDispatcher;
	
	/**
	 * The interface definition for a RobotLegs Context
	 */
	public interface IContext
	{
		/**
		 * Execute the <code>IContext</code>'s startup method
		 */
		function startup():void;
		
		/**
		 * Return this <code>IContext</code>'s IEventDispatcher
		 * @return The <code>IContext</code>'s IEventDispatcher
		 */
		function getEventDispatcher():IEventDispatcher;
	}
}