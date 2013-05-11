//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.api
{

	/**
	 * An extension integrates a library into a Context
	 */
	public interface IExtension
	{
		/**
		 * This method will be called immediately when the extension/bundle is installed.
		 *
		 * <p>Note: the context may not be fully initialized yet. A bundle should do
		 * little more than install additional bundles/extensions. An extension
		 * can add lifecycle handlers to the context instance to perform synchronized
		 * initialization.</p>
		 *
		 * @param context The context that this extension/bundle is being installed into.
		 */
		function extend(context:IContext):void;
	}
}
