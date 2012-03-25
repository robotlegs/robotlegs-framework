//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.scopedMessageDispatcher
{
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.core.messaging.IMessageDispatcher;
	import robotlegs.bender.core.messaging.MessageDispatcher;
	import robotlegs.bender.framework.context.api.IContext;
	import robotlegs.bender.framework.context.api.IContextExtension;
	import robotlegs.bender.framework.object.managed.impl.ManagedObject;

	/**
	 * This extensions maps a series of named IMessageDispatcher instances
	 * provided those names have not been mapped by a parent context.
	 */
	public class ScopedMessageDispatcherExtension implements IContextExtension
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _names:Array;

		private var _context:IContext;

		private var _injector:Injector;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function ScopedMessageDispatcherExtension(... names)
		{
			_names = (names.length > 0) ? names : ["global"];
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function extend(context:IContext):void
		{
			_context = context;
			_injector = context.injector;
			_context.addStateHandler(ManagedObject.SELF_INITIALIZE, handleContextSelfInitialize);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function handleContextSelfInitialize():void
		{
			for each (var name:String in _names)
			{
				if (!_injector.satisfies(IMessageDispatcher, name))
				{
					_injector
						.map(IMessageDispatcher, name)
						.toValue(new MessageDispatcher());
				}
			}
		}
	}
}
