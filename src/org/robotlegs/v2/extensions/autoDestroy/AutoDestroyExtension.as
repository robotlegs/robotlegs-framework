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
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.api.IContextExtension;
	import org.robotlegs.v2.core.api.ILogger;
	import org.robotlegs.v2.core.impl.Logger;

	public class AutoDestroyExtension implements IContextExtension
	{

		private var context:IContext;

		private var contextView:DisplayObjectContainer;

		private var logger:ILogger;

		public function install(context:IContext):void
		{
			this.context = context;
			logger = new Logger(context.id + ' AutoDestroyExtension', context.logger.target);
			contextView = context.contextView;
			if (contextView)
			{
				logger.info('adding REMOVED_FROM_STAGE listener to contextView');
				contextView.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			}
			else
			{
				logger.warn('extension installed, but the contextView is null. Consider removing this extension.');
			}
		}

		public function initialize():void
		{
		}

		public function uninstall():void
		{
			if (contextView)
			{
				logger.info('removing REMOVED_FROM_STAGE listener from contextView');
				contextView.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			}
		}

		private function onRemovedFromStage(event:Event):void
		{
			logger.info('contextView was removed from stage, destroying context');
			contextView.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			context.destroy();
		}
	}
}
