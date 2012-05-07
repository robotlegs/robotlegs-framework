//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
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
	import robotlegs.bender.framework.impl.UID;

	/**
	 * This extensions maps a series of named IMessageDispatcher instances
	 * provided those names have not been mapped by a parent context.
	 */
	public class ScopedMessageDispatcherExtension implements IExtension
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _uid:String = UID.create(ScopedMessageDispatcherExtension);

		private var _names:Array;

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
			_injector = context.injector;
			context.lifecycle.whenInitializing(handleContextSelfInitialize);
		}

		public function toString():String
		{
			return _uid;
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
