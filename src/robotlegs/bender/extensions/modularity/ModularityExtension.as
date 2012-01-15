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
	import robotlegs.bender.extensions.contextView.ContextViewExtension;
	import robotlegs.bender.extensions.modularity.events.ModularContextEvent;
	import robotlegs.bender.framework.context.api.IContext;
	import robotlegs.bender.framework.context.api.IContextConfig;
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

		private var _context:IContext;

		private var _injector:Injector;

		private var _inherit:Boolean;

		private var _export:Boolean;

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
			// todo: I'm not convinced that extensions should slurp in their dependencies
			_context = context.require(ContextViewExtension);
			_injector = context.injector;
			_context.addStateHandler(ManagedObject.PRE_INITIALISE, handleContextPreInitialize);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function handleContextPreInitialize():void
		{
			if (!_injector.satisfiesDirectly(DisplayObjectContainer))
				throw new Error("This extension requires a DisplayObjectContainer to mapped.");

			const contextView:DisplayObjectContainer = _injector.getInstance(DisplayObjectContainer);

			if (_inherit)
				contextView.dispatchEvent(new ModularContextEvent(ModularContextEvent.CONTEXT_ADD, _context));

			if (_export)
				contextView.addEventListener(ModularContextEvent.CONTEXT_ADD, onContextAdd);
		}

		private function onContextAdd(event:ModularContextEvent):void
		{
			event.stopImmediatePropagation();
			event.context.injector.parentInjector = _context.injector;
		}
	}
}
