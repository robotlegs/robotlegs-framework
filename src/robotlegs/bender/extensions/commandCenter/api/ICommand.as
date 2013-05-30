//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.api
{

	/**
	 * Optional Command interface.
	 *
	 * <p>Note, you do not need to implement this interface,
	 * any class with an execute method can be used.</p>
	 */
	public interface ICommand
	{
		/**
		 * The execute method
		 */
		function execute():void;
	}
}
