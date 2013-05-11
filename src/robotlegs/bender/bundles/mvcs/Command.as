//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.bundles.mvcs
{
	import robotlegs.bender.extensions.commandCenter.api.ICommand;

	/**
	 * Abstract command implementation
	 *
	 * <p>Please note: you do not have to extend this class.
	 * Any class with an execute method can be used.</p>
	 */
	public class Command implements ICommand
	{

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function execute():void
		{
		}
	}
}
