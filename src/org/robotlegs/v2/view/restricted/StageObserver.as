//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.view.restricted
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	import org.robotlegs.v2.view.api.IContainerBinding;
	import org.robotlegs.v2.view.api.IDisplayList;
	import org.robotlegs.v2.view.api.IDisplayListObserver;

	public class StageObserver implements IDisplayListObserver
	{

		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/

		protected var container:DisplayObjectContainer;

		protected var displayList:IDisplayList;

		protected const excludePattern:RegExp = /^mx\.|^spark\.|^flash\./;


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function configure(displayList:IDisplayList):void
		{
			this.displayList = displayList;
			container = displayList.rootContainerBinding.container;
			container.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, true, 0, true);
			container.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, true, 0, true);
		}

		public function destroy():void
		{
			container.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage, true);
			container.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, true);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function onAddedToStage(event:Event):void
		{
			const target:DisplayObject = event.target as DisplayObject;
			const className:String = getQualifiedClassName(target);
			if (className.match(excludePattern))
				return;

			var binding:IContainerBinding = displayList.findParentBinding(target);
			var response:ViewHandlerResponse;
			while (binding)
			{
				response = binding.handler.addView(target, className);

				if (response == ViewHandlerResponse.STOP)
					return;

				binding = binding.parent;
			}
		}

		private function onRemovedFromStage(event:Event):void
		{
			const target:DisplayObject = event.target as DisplayObject;
			const className:String = getQualifiedClassName(target);
			if (className.match(excludePattern))
				return;

			var binding:IContainerBinding = displayList.findParentBinding(target);
			var response:ViewHandlerResponse;
			while (binding)
			{
				response = binding.handler.removeView(target, className);

				if (response == ViewHandlerResponse.STOP)
					return;

				binding = binding.parent;
			}

		}
	}
}
