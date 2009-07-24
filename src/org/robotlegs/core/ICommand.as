package org.robotlegs.core
{
	
	/**
	 * The interface definition for a RobotLegs Command
	 */
	public interface ICommand
	{
		/**
		 * Execute the <code>ICommand</code>'s logic
		 * Declare the concrete <code>Event</code> as a dependency if you need access to the <code>Event</code> that triggered this command
		 */
		function execute():void;
	}

}