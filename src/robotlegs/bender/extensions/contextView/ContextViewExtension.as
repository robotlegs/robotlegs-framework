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
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;
	import robotlegs.bender.framework.api.ILogger;
	import robotlegs.bender.framework.impl.UID;

	/**
	 * <p>This Extension waits for a DisplayObjectContainer to be added as a configuration
	 * and maps that container into the context's injector.</p>
	 *
	 * <p>It should be installed before context initialization.</p>
	 */
	public class ContextViewExtension implements IExtension
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _uid:String = UID.create(ContextViewExtension);

		private var _injector:Injector;

		private var _logger:ILogger;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		// todo: accept contextView via constructor and use that if provided

		public function extend(context:IContext):void
		{
			_injector = context.injector;
			_logger = context.getLogger(this);
			context.addConfigHandler(instanceOf(DisplayObjectContainer), handleContextView);
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
			if (_injector.satisfiesDirectly(DisplayObjectContainer))
			{
				_logger.warn('A contextView has already been mapped, ignoring {0}', [view]);
			}
			else
			{
				_logger.debug("Mapping {0} as contextView", [view]);
				_injector.map(DisplayObjectContainer).toValue(view);
			}
		}
	}
}
