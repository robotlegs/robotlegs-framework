//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap.support
{
	import robotlegs.bender.framework.api.IInjector;

	public class TrackingProcessor implements ITrackingProcessor
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private const _processedViews:Array = [];

		public function get processedViews():Array
		{
			return _processedViews;
		}

		private const _unprocessedViews:Array = [];

		public function get unprocessedViews():Array
		{
			return _unprocessedViews;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function process(view:Object, type:Class, injector:IInjector):void
		{
			_processedViews.push(view);
		}

		public function unprocess(view:Object, type:Class, injector:IInjector):void
		{
			_unprocessedViews.push(view);
		}
	}

}

