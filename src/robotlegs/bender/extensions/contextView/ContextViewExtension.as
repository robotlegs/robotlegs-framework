//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.contextView
{
	import flash.display.DisplayObjectContainer;
	import org.hamcrest.object.instanceOf;
	import robotlegs.bender.framework.context.api.IContext;
	import robotlegs.bender.framework.context.api.IContextExtension;
	import robotlegs.bender.framework.logging.api.ILogger;
	import robotlegs.bender.framework.object.identity.UID;

	/**
	 * <p>This Extension waits for a DisplayObjectContainer to be added as a configuration
	 * and maps that container into the context's injector.</p>
	 *
	 * <p>It should be installed before context initialization.</p>
	 */
	public class ContextViewExtension implements IContextExtension
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _uid:String = UID.create(ContextViewExtension);

		private var _context:IContext;

		private var _logger:ILogger;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		// todo: accept contextView via constructor and use that if provided

		public function extend(context:IContext):void
		{
			_context = context;
			_logger = context.getLogger(this);
			_context.addConfigHandler(instanceOf(DisplayObjectContainer), handleContextView);
		}

		public function toString():String
		{
			return _uid;
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function handleContextView(view:DisplayObjectContainer):void
		{
			_logger.debug("Mapping provided DisplayObjectContainer as contextView...");
			_context.injector.map(DisplayObjectContainer).toValue(view);
		}
	}
}
