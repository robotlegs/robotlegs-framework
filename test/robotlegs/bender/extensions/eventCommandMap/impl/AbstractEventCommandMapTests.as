//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventCommandMap.impl
{
	import flash.events.EventDispatcher;
	import robotlegs.bender.extensions.commandMap.api.ICommandMap;
	import robotlegs.bender.extensions.commandMap.impl.CommandMap;
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import org.swiftsuspenders.Injector;

	public class AbstractEventCommandMapTests
	{
		protected var injector:Injector;

		protected var dispatcher:EventDispatcher;

		protected var eventCommandMap:IEventCommandMap;

		private var commandMap:ICommandMap;

		[Before]
		public function setUp():void
		{
			injector = new Injector();
			dispatcher = new EventDispatcher();
			commandMap = new CommandMap();
			eventCommandMap = new EventCommandMap(injector, dispatcher, commandMap);
		}

		[After]
		public function tearDown():void
		{
			injector = null;
			dispatcher = null;
			commandMap = null;
			eventCommandMap = null;
		}
	}
}
