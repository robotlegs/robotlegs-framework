//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl.safelyCallBackSupport
{
	import flash.utils.setTimeout;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * This helper creates an asynchronous Handler that waits 5 ms
	 * and then invokes the supplied closure with the given params
	 * (if provided) and finally calls back.
	 */
	public function createAsyncHandler(closure:Function = null, ... params):Function
	{
		return function(message:Object, callback:Function):void {
			setTimeout(function():void {
				closure && closure.apply(null, params);
				callback();
			}, 5);
		};
	}
}
