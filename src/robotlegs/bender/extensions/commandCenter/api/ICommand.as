//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.api
{

	/**
	 * Abstract command implementation
	 *
	 * <p>Please note: you do not have to implement this interface.
	 * Any class with an execute method can be used.</p>
	 */
	public interface ICommand
	{
		/**
		 * Command execution hook.
		 */
		function execute():void;
	}
}
