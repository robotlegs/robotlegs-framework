//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl.safelyCallBackSupport
{

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * This helper creates a synchronous Handler
	 * that invokes the supplied closure with the given params
	 * (if provided).
	 */
	public function createHandler(closure:Function = null, ... params):Function
	{
		return function():void {
			closure && closure.apply(null, params);
		};
	}
}
