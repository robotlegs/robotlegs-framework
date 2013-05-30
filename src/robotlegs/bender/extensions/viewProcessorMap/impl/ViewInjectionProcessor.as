//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap.impl
{
	import flash.utils.Dictionary;
	import robotlegs.bender.framework.api.IInjector;

	/**
	 * Default View Injection Processor implementation
	 * @private
	 */
	public class ViewInjectionProcessor
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _injectedObjects:Dictionary = new Dictionary(true);

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @private
		 */
		public function process(view:Object, type:Class, injector:IInjector):void
		{
			_injectedObjects[view] || injectAndRemember(view, injector);
		}

		/**
		 * @private
		 */
		public function unprocess(view:Object, type:Class, injector:IInjector):void
		{
			// assumption is that teardown is not wanted.
			// if you *do* want teardown, copy this class
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function injectAndRemember(view:Object, injector:IInjector):void
		{
			injector.injectInto(view);
			_injectedObjects[view] = view;
		}
	}
}
