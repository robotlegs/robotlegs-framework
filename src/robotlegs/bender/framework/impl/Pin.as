//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{
	import flash.utils.Dictionary;

	public class Pin
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _instances:Dictionary = new Dictionary(false);

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function detain(instance:Object):void
		{
			_instances[instance] = true;
		}

		public function release(instance:Object):void
		{
			delete _instances[instance];
		}

		public function flush():void
		{
			for each (var key:* in _instances)
			{
				delete _instances[key];
			}
		}
	}
}
