//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.autoDestroy
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.api.IContextExtension;

	public class AutoDestroyExtension implements IContextExtension
	{

		private static const logger:ILogger = getLogger(AutoDestroyExtension);

		private var context:IContext;

		private var contextView:DisplayObjectContainer;

		public function install(context:IContext):void
		{
			this.context = context;
			contextView = context.contextView;
			if (contextView)
			{
				logger.info('installing AutoDestroyExtension into {0}', [context]);
				contextView.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			}
			else
			{
				logger.warn('an AutoDestroyExtension was installed into {0}, but the contextView is null. Consider removing this extension.', [context]);
			}
		}

		public function initialize():void
		{
		}

		public function uninstall():void
		{
			logger.info('uninstalling AutoDestroyExtension from {0}', [context]);
			if (contextView)
			{
				contextView.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			}
		}

		private function onRemovedFromStage(event:Event):void
		{
			logger.info('contextView was removed from stage, destroying context {0}', [context]);
			contextView.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			context.destroy();
		}
	}
}
