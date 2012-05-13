//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.modularity.impl
{
	import flash.display.DisplayObjectContainer;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.ILogger;
	import robotlegs.bender.framework.impl.UID;

	public class ContextViewBasedExistenceWatcher
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _uid:String = UID.create(ContextViewBasedExistenceWatcher);

		private var _logger:ILogger;

		private var _injector:Injector;

		private var _contextView:DisplayObjectContainer;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function ContextViewBasedExistenceWatcher(context:IContext, contextView:DisplayObjectContainer)
		{
			_logger = context.getLogger(this);
			_injector = context.injector;
			_contextView = contextView;
			context.lifecycle.whenDestroying(destroy);
			init();
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function toString():String
		{
			return _uid;
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function init():void
		{
			_logger.debug("Listening for context existence events on contextView {0}", [_contextView]);
			_contextView.addEventListener(ModularContextEvent.CONTEXT_ADD, onContextAdd);
		}

		private function destroy():void
		{
			_logger.debug("Removing modular context existence event listener from contextView {0}", [_contextView]);
			_contextView.removeEventListener(ModularContextEvent.CONTEXT_ADD, onContextAdd);
		}

		private function onContextAdd(event:ModularContextEvent):void
		{
			_logger.debug("Context existence event caught. Configuring child context {0}", [event.context]);
			event.stopImmediatePropagation();
			event.context.injector.parentInjector = _injector;
		}
	}
}
