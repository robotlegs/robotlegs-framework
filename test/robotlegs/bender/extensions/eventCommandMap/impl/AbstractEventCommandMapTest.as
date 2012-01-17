//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventCommandMap.impl
{
	import flash.events.EventDispatcher;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.commandMap.api.ICommandMap;
	import robotlegs.bender.extensions.commandMap.impl.CommandMap;
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;

	public class AbstractEventCommandMapTest
	{

		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/

		protected var injector:Injector;

		protected var dispatcher:EventDispatcher;

		protected var eventCommandMap:IEventCommandMap;

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var commandMap:ICommandMap;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			injector = new Injector();
			dispatcher = new EventDispatcher();
			commandMap = new CommandMap();
			eventCommandMap = new EventCommandMap(injector, dispatcher, commandMap);
		}

		[After]
		public function after():void
		{
			injector = null;
			dispatcher = null;
			commandMap = null;
			eventCommandMap = null;
		}
	}
}
