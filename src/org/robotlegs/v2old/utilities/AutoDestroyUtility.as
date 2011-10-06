//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2old.utilities
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import org.robotlegs.v2.core.api.IContext;

	public class AutoDestroyUtility
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		[Inject]
		public var context:IContext;

		[Inject]
		public var contextView:DisplayObjectContainer;


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		[PostConstruct]
		public function init():void
		{
			contextView.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function onRemovedFromStage(event:Event):void
		{
			contextView.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			context.destroy();
		}
	}
}
