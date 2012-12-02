//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{
	import flash.utils.Dictionary;

	/**
	 * Pins objects in memory
	 *
	 * @private
	 */
	public class Pin
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _instances:Dictionary = new Dictionary(false);

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * Pin an object in memory
		 * @param instance Instance to pin
		 */
		public function detain(instance:Object):void
		{
			_instances[instance] = true;
		}

		/**
		 * Unpins an object
		 * @param instance Instance to unpin
		 */
		public function release(instance:Object):void
		{
			delete _instances[instance];
		}

		/**
		 * Removes all pins
		 */
		public function flush():void
		{
			for (var instance:Object in _instances)
			{
				delete _instances[instance];
			}
		}
	}
}
