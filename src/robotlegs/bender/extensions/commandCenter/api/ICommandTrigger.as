//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.api
{

	/**
	 * @private
	 */
	public interface ICommandTrigger
	{
		/**
		 * Invoked when the trigger should be activated.
		 *
		 * <p>Use this to add event listeners or Signal handlers.</p>
		 */
		function activate():void;

		/**
		 * Invoked when the trigger should be deactivated.
		 *
		 * <p>Use this to remove event listeners or Signal handlers.</p>
		 */
		function deactivate():void;
	}
}
