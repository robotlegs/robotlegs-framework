package org.robotlegs.core
{

	/**
	 * The interface definition for a RobotLegs CommandFactory
	 */
	public interface ICommandFactory
	{
		/**
		 * Map an <code>ICommand</code> Class to an Event type
		 * @param type The Event type to listen for
		 * @param commandClass The <code>ICommand</code> Class to instantiate and execute
		 * @param oneshot Unmap the <code>ICommand</code> Class after execution?
		 */
		function mapCommand( type:String, commandClass:Class, oneshot:Boolean = false ):void;

		/**
		 * Unmap an <code>ICommand</code> Class to Event type mapping
		 * @param type The Event type
		 * @param commandClass The <code>ICommand</code> Class to unmap
		 */
		function unmapCommand( type:String, commandClass:Class ):void;

		/**
		 * Check if an <code>ICommand</code> Class has been mapped to an Event type
		 * @param type The Event type
		 * @param commandClass The <code>ICommand</code> Class
		 * @return Whether the <code>ICommand</code> is mapped to this Event type
		 */
		function hasCommand( type:String, commandClass:Class ):Boolean;
	}
}