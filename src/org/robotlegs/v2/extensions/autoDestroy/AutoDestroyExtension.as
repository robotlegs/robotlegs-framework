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
	import flash.utils.Dictionary;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.api.IContextExtension;

	public class AutoDestroyExtension implements IContextExtension
	{

		private static const logger:ILogger = getLogger(AutoDestroyExtension);

		private const contextsByContextView:Dictionary = new Dictionary();

		public function initialize(context:IContext):void
		{
		}

		public function install(context:IContext):void
		{
			const contextView:DisplayObjectContainer = context.contextView;
			if (contextView)
			{
				logger.info('installing AutoDestroyExtension into {0}', [context]);
				contextsByContextView[contextView] = context;
				contextView.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			}
			else
			{
				logger.warn('an AutoDestroyExtension was installed into {0}, but the contextView is null. Consider removing this extension.', [context]);
			}
		}

		public function uninstall(context:IContext):void
		{
			logger.info('uninstalling AutoDestroyExtension from {0}', [context]);
			const contextView:DisplayObjectContainer = context.contextView;
			if (contextView)
			{
				contextView.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
				delete contextsByContextView[contextView];
			}
		}

		private function onRemovedFromStage(event:Event):void
		{
			const contextView:DisplayObjectContainer = event.target as DisplayObjectContainer;
			const context:IContext = contextsByContextView[contextView]
			logger.info('contextView was removed from stage, destroying context {0}', [context]);
			contextView.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			context.destroy();
		}
	}
}
