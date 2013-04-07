//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.impl
{
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;

	/**
	 * @private
	 */
	public class NullCommandUnmapper implements ICommandUnmapper
	{

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function fromCommand(commandClass:Class):void
		{
		}

		/**
		 * @inheritDoc
		 */
		public function fromAll():void
		{
		}
	}
}
