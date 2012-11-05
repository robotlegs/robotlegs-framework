//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.stageSync
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import org.hamcrest.object.instanceOf;

	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;
	import robotlegs.bender.framework.api.ILogger;
	import robotlegs.bender.framework.impl.UID;

	/**
	 * <p>This Extension waits for a ContextView to be added as a configuration,
	 * and initializes and destroys the context based on the contextView's stage presence.</p>
	 *
	 * <p>It should be installed before context initialization.</p>
	 */
	public class StageSyncExtension implements IExtension
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _uid:String = UID.create(StageSyncExtension);

		private var _context:IContext;

		private var _contextView:DisplayObjectContainer;

		private var _logger:ILogger;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function extend(context:IContext):void
		{
			_context = context;
			_logger = context.getLogger(this);
			_context.addConfigHandler(
				instanceOf(ContextView),
				handleContextView);
		}

		public function toString():String
		{
			return _uid;
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function handleContextView(contextView:ContextView):void
		{
			if (_contextView)
			{
				_logger.warn('A contextView has already been installed, ignoring {0}', [contextView.view]);
				return;
			}
			_contextView = contextView.view;
			if (_contextView.stage)
			{
				initializeContext();
			}
			else
			{
				_logger.debug("Context view is not yet on stage. Waiting...");
				_contextView.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}
		}

		private function onAddedToStage(event:Event):void
		{
			_contextView.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			initializeContext();
		}

		private function initializeContext():void
		{
			_logger.debug("Context view is now on stage. Initializing context...");
			_context.lifecycle.initialize();
			_contextView.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}

		private function onRemovedFromStage(event:Event):void
		{
			_logger.debug("Context view has left the stage. Destroying context...");
			_contextView.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			_context.lifecycle.destroy();
		}
	}
}
