//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.api
{

	/**
	 * A guard is expected to expose an "approve" method that returns a boolean
	 *
	 * <p>Note: a guard does not need to implement this interface.</p>
	 */
	public interface IGuard
	{
		function approve():Boolean;
	}
}
