//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.support
{

	public class CallbackMediator
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		[Inject(name='callback', optional='true')]
		public var callback:Function;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		[PostConstruct]
		public function init():void
		{
			callback && callback(this);
		}
	}
}
