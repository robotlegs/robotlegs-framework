package org.robotlegs.core
{

	/**
	 * The interface definition for a RobotLegs Command
	 */
	public interface ICommand
	{
		/**
		 * Execute the <code>ICommand</code>'s logic
		 */
		function execute():void;
	}

}