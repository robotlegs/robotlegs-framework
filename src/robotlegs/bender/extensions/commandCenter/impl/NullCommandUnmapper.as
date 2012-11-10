//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.impl
{
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;

	public class NullCommandUnmapper implements ICommandUnmapper
	{

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function fromCommand(commandClass:Class):void
		{

		}

		public function fromAll():void
		{

		}
	}
}
