//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.modularity
{
	import flash.display.DisplayObjectContainer;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.modularity.impl.ContextViewBasedExistenceWatcher;
	import robotlegs.bender.extensions.modularity.impl.ModularContextEvent;
	import robotlegs.bender.extensions.modularity.impl.ViewManagerBasedExistenceWatcher;
	import robotlegs.bender.extensions.viewManager.api.IViewManager;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;
	import robotlegs.bender.framework.api.ILogger;
	import robotlegs.bender.framework.impl.UID;

	/**
	 * This extension allows a context to inherit dependencies from a parent context,
	 * and/or expose its dependencies to child contexts.
	 *
	 * <p>It must be installed before context initialization.</p>
	 */
	public class ModularityExtension implements IExtension
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _uid:String = UID.create(ModularityExtension);

		private var _context:IContext;

		private var _injector:Injector;

		private var _logger:ILogger;

		private var _inherit:Boolean;

		private var _expose:Boolean;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * Modularity
		 *
		 * @param inherit Should this context inherit dependencies?
		 * @param expose Should this context expose its dependencies?
		 */
		public function ModularityExtension(inherit:Boolean = true, expose:Boolean = true)
		{
			_inherit = inherit;
			_expose = expose;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function extend(context:IContext):void
		{
			_context = context;
			_injector = context.injector;
			_logger = context.getLogger(this);
			_context.lifecycle.beforeInitializing(beforeInitializing);
		}

		public function toString():String
		{
			return _uid;
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function beforeInitializing():void
		{
			_inherit && broadcastContextExistence();
			_expose && createContextWatcher();
		}

		private function broadcastContextExistence():void
		{
			if (_injector.satisfiesDirectly(DisplayObjectContainer))
			{
				_logger.debug("Context configured to inherit. Broadcasting existence event...");
				const contextView:DisplayObjectContainer = _injector.getInstance(DisplayObjectContainer);
				contextView.dispatchEvent(new ModularContextEvent(ModularContextEvent.CONTEXT_ADD, _context));
			}
			else
			{
				_logger.warn("Context has been configured to inherit dependencies but has no way to do so");
			}
		}

		private function createContextWatcher():void
		{
			if (_injector.satisfiesDirectly(IViewManager))
			{
				_logger.debug("Context has a ViewManager. Configuring view manager based context existence watcher...");
				const viewManager:IViewManager = _injector.getInstance(IViewManager);
				new ViewManagerBasedExistenceWatcher(_context, viewManager);
			}
			else if (_injector.satisfiesDirectly(DisplayObjectContainer))
			{
				_logger.debug("Context has a ContextView. Configuring context view based context existence watcher...");
				const contextView:DisplayObjectContainer = _injector.getInstance(DisplayObjectContainer);
				new ContextViewBasedExistenceWatcher(_context, contextView);
			}
			else
			{
				_logger.warn("Context has been configured to expose its dependencies but has no way to do so");
			}
		}
	}
}
