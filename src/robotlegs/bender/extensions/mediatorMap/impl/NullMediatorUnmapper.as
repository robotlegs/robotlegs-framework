//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl
{
	import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorUnmapper;

	public class NullMediatorUnmapper implements IMediatorUnmapper
	{

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function fromMediator(mediatorClass:Class):void
		{
		}

		public function fromAll():void
		{
		}
	}
}
