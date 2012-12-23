//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.scopedMessageDispatcher
{
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;
	import robotlegs.bender.framework.api.IMessageDispatcher;
	import robotlegs.bender.framework.impl.MessageDispatcher;

	/**
	 * This extensions maps a series of named IMessageDispatcher instances
	 * provided those names have not been mapped by a parent context.
	 */
	public class ScopedMessageDispatcherExtension implements IExtension
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _names:Array;

		private var _injector:Injector;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * Creates a Scoped Message Dispatcher Extension
		 *
		 * <p>Note: Names that have already been registered with a parent context
		 * will not be mapped into this context Injector and will instead be inherited.</p>
		 *
		 * @param names A list of IMessageDispatcher names to map into the Injector
		 */
		public function ScopedMessageDispatcherExtension(... names)
		{
			_names = (names.length > 0) ? names : ["global"];
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function extend(context:IContext):void
		{
			_injector = context.injector;
			context.whenInitializing(whenInitializing);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function whenInitializing():void
		{
			for each (var name:String in _names)
			{
				if (!_injector.hasMapping(IMessageDispatcher, name))
				{
					_injector
						.map(IMessageDispatcher, name)
						.toValue(new MessageDispatcher());
				}
			}
		}
	}
}
