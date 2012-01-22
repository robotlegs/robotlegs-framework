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
	import robotlegs.bender.extensions.modularity.events.ModularContextEvent;
	import robotlegs.bender.framework.context.api.IContext;
	import robotlegs.bender.framework.context.api.IContextConfig;
	import robotlegs.bender.framework.logging.api.ILogger;
	import robotlegs.bender.framework.object.identity.UID;
	import robotlegs.bender.framework.object.managed.impl.ManagedObject;

	/**
	 * <p>This extension allows a context to inherit dependencies from a parent context,
	 * and to expose its dependences to child contexts.</p>
	 *
	 * <p>It should be installed before context initialization.</p>
	 */
	public class ModularityExtension implements IContextConfig
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _uid:String = UID.create(ModularityExtension);

		private var _context:IContext;

		private var _injector:Injector;

		private var _logger:ILogger;

		private var _inherit:Boolean;

		private var _export:Boolean;

		private var _contextView:DisplayObjectContainer;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * Modularity
		 *
		 * @param inherit Should this context inherit dependencies?
		 * @param export Should this context expose its dependencies?
		 */
		public function ModularityExtension(inherit:Boolean = true, export:Boolean = true)
		{
			_inherit = inherit;
			_export = export;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function configureContext(context:IContext):void
		{
			_context = context;
			_injector = context.injector;
			_logger = context.getLogger(this);
			_context.addStateHandler(ManagedObject.PRE_INITIALIZE, handleContextPreInitialize);
			_context.addStateHandler(ManagedObject.PRE_DESTROY, handleContextPreDestroy);
		}

		public function toString():String
		{
			return _uid;
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function handleContextPreInitialize():void
		{
			if (!_injector.satisfiesDirectly(DisplayObjectContainer))
				throw new Error("This extension requires a DisplayObjectContainer to mapped.");

			_contextView = _injector.getInstance(DisplayObjectContainer);
			_inherit && broadcastExistence();
			_export && addExistenceListener();
		}

		private function handleContextPreDestroy():void
		{
			_logger.debug("Removing modular context existence event listener...");
			_export && _contextView.removeEventListener(ModularContextEvent.CONTEXT_ADD, onContextAdd);
		}

		private function broadcastExistence():void
		{
			_logger.debug("Modular context configured to inherit. Broadcasting existence event...");
			_contextView.dispatchEvent(new ModularContextEvent(ModularContextEvent.CONTEXT_ADD, _context));
		}

		private function addExistenceListener():void
		{
			_logger.debug("Modular context configured to export. Listening for existence events...");
			_contextView.addEventListener(ModularContextEvent.CONTEXT_ADD, onContextAdd);
		}

		private function onContextAdd(event:ModularContextEvent):void
		{
			_logger.debug("Modular context existence message caught. Configuring child module...");
			event.stopImmediatePropagation();
			event.context.injector.parentInjector = _context.injector;
		}
	}
}
