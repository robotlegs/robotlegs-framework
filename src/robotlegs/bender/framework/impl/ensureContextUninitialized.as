//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{
	import robotlegs.bender.framework.api.IContext;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function ensureContextUninitialized(context:IContext, logSource:Object):void
	{
		// TODO: Better solution needed
		if (!context.uninitialized)
		{
			context.getLogger(logSource).warn("This extension must be installed into an uninitialized context");
		}
	}
}
