//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.api
{
	import robotlegs.bender.extensions.viewManager.api.IViewHandler;

	/**
	 * @private
	 */
	public interface IMediatorViewHandler extends IViewHandler
	{
		/**
		 * @private
		 */
		function addMapping(mapping:IMediatorMapping):void;

		/**
		 * @private
		 */
		function removeMapping(mapping:IMediatorMapping):void;

		/**
		 * @private
		 */
		function handleItem(item:Object, type:Class):void;
	}
}
