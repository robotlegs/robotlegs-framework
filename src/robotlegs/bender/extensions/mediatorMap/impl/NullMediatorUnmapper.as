//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl
{
	import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorUnmapper;

	/**
	 * @private
	 */
	public class NullMediatorUnmapper implements IMediatorUnmapper
	{

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @private
		 */
		public function fromMediator(mediatorClass:Class):void
		{
		}

		/**
		 * @private
		 */
		public function fromAll():void
		{
		}
	}
}
