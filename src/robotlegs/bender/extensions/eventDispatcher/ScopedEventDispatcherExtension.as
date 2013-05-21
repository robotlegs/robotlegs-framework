//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventDispatcher
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;

	/**
	 * This extensions maps a series of named IEventDispatcher instances
	 * provided those names have not been mapped by a parent context.
	 */
	public class ScopedEventDispatcherExtension implements IExtension
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
		 * Creates a Scoped Event Dispatcher Extension
		 *
		 * <p>Note: Names that have already been registered with a parent context
		 * will not be mapped into this context Injector and will instead be inherited.</p>
		 *
		 * @param names A list of IEventDispatcher names to map into the Injector
		 */
		public function ScopedEventDispatcherExtension(... names)
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
				if (!_injector.satisfies(IEventDispatcher, name))
				{
					_injector
						.map(IEventDispatcher, name)
						.toValue(new EventDispatcher());
				}
			}
		}
	}
}
