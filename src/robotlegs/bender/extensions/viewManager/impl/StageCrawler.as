//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager.impl
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class StageCrawler
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _binding:ContainerBinding;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function StageCrawler(containerBinding:ContainerBinding)
		{
			_binding = containerBinding;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function scan(view:DisplayObjectContainer):void
		{
			scanContainer(view);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function scanContainer(container:DisplayObjectContainer):void
		{
			processView(container);
			const numChildren:int = container.numChildren;
			for (var i:int = 0; i < numChildren; i++)
			{
				const child:DisplayObject = container.getChildAt(i);
				child is DisplayObjectContainer
					? scanContainer(child as DisplayObjectContainer)
					: processView(child);
			}
		}

		private function processView(view:DisplayObject):void
		{
			_binding.handleView(view, view['constructor']);
		}
	}
}
