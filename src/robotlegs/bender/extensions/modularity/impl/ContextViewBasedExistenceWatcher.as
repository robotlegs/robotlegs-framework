//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.modularity.impl
{
	import flash.display.DisplayObjectContainer;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.ILogger;

	/**
	 * @private
	 */
	public class ContextViewBasedExistenceWatcher
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _logger:ILogger;

		private var _contextView:DisplayObjectContainer;

		private var _parentContext:IContext;

		private var _childContext:IContext;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * @private
		 */
		public function ContextViewBasedExistenceWatcher(context:IContext, contextView:DisplayObjectContainer)
		{
			_logger = context.getLogger(this);
			_contextView = contextView;
			_parentContext = context;
			_parentContext.lifecycle.whenDestroying(destroy);
			init();
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
			if (_childContext)
			{
				_logger.debug("Unlinking parent injector for child context {0}", [_childContext]);
				_parentContext.removeChild(_childContext);
			}
		}

		private function onContextAdd(event:ModularContextEvent):void
		{
			event.stopImmediatePropagation();
			_childContext = event.context;
			_logger.debug("Context existence event caught. Configuring child context {0}", [_childContext]);
			_parentContext.addChild(_childContext);
		}
	}
}
