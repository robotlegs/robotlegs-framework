//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventDispatcher
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import robotlegs.bender.framework.context.api.IContext;
	import robotlegs.bender.framework.context.api.IContextExtension;

	/**
	 * This extension maps an IEventDispatcher into a context's injector.
	 */
	public class EventDispatcherExtension implements IContextExtension
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _eventDispatcher:IEventDispatcher;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function EventDispatcherExtension(eventDispatcher:IEventDispatcher = null)
		{
			_eventDispatcher = eventDispatcher || new EventDispatcher();
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function extend(context:IContext):void
		{
			context.injector.map(IEventDispatcher).toValue(_eventDispatcher);
		}
	}
}
