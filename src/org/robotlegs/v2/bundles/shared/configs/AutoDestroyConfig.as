//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.bundles.shared.configs
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.api.IContextConfig;

	public class AutoDestroyConfig implements IContextConfig
	{

		/*============================================================================*/
		/* Private Static Properties                                                  */
		/*============================================================================*/

		private static const logger:ILogger = getLogger(AutoDestroyConfig);


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

		public function configure(context:IContext):void
		{
			if (contextView)
			{
				contextView.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			}
			else
			{
				logger.warn('an AutoDestroyConfig was installed into {0}, but the contextView is null. Consider removing this config.', [context]);
			}
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
