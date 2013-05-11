//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager.api
{
	import flash.display.DisplayObject;

	/**
	 * View handler contract
	 */
	public interface IViewHandler
	{
		/**
		 * View handler method
		 * @param view The view instance to handle
		 * @param type The class of the view instance
		 */
		function handleView(view:DisplayObject, type:Class):void;
	}
}
