//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.api
{

	/**
	 * Optional application configuration interface
	 *
	 * <p>Note: a config does not need to implement this interface. But, it is highly recommended.</p>
	 */
	public interface IConfig
	{
		/**
		 * Configure will be invoked after dependencies have been supplied
		 */
		function configure():void;
	}
}
