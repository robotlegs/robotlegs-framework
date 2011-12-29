//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.autoDestroy
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import robotlegs.bender.core.api.IContext;
	import robotlegs.bender.core.api.IContextExtension;
	import robotlegs.bender.core.api.IContextLogger;

	public class AutoDestroyExtension implements IContextExtension
	{

		private var context:IContext;

		private var contextView:DisplayObjectContainer;

		private var logger:IContextLogger;

		public function install(context:IContext):void
		{
			this.context = context;
			logger = context.logger;
			contextView = context.contextView;

			if (contextView)
			{
				logger.info(this, 'Adding REMOVED_FROM_STAGE listener to contextView');
				contextView.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			}
			else
			{
				logger.warn(this, 'Extension installed, but the contextView is null. Consider removing this extension.');
			}
		}

		public function initialize():void
		{
		}

		public function uninstall():void
		{
			if (contextView)
			{
				logger.info(this, 'Removing REMOVED_FROM_STAGE listener from contextView');
				contextView.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			}
		}

		public function toString():String
		{
			return 'AutoDestroyExtension';
		}

		private function onRemovedFromStage(event:Event):void
		{
			logger.info(this, 'ContextView was removed from stage, destroying context.');
			contextView.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			context.destroy();
		}
	}
}
