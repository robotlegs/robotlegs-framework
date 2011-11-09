//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.commandMap.impl
{
	import flash.events.EventDispatcher;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandMap;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandTrigger;
	import org.robotlegs.v2.extensions.commandMap.support.SupportEvent;
	import org.swiftsuspenders.Injector;

	public class AbstractCommandMapTests
	{
		protected var commandMap:ICommandMap;

		protected var injector:Injector;

		protected var dispatcher:EventDispatcher;

		protected var trigger:ICommandTrigger;

		[Before]
		public function setUp():void
		{
			injector = new Injector();
			dispatcher = new EventDispatcher()
			commandMap = new CommandMap(injector, dispatcher);
			trigger = new EventCommandTrigger(injector, dispatcher, SupportEvent.TYPE1, SupportEvent);
		}

		[After]
		public function tearDown():void
		{
			injector = null;
			dispatcher = null;
			commandMap = null;
		}
	}
}
