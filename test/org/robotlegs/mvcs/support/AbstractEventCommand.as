/*
 * Copyright (c) 2009 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package org.robotlegs.mvcs.support
{

	import flash.events.Event;

	public class AbstractEventCommand
	{

		[Inject]
		public var event:Event;

		[Inject]
		public var customEvent:CustomEvent;

		[Inject]
		public var testSuite:ICommandTest;

		public function execute():void
		{
			if (event && event == customEvent)
				testSuite.markCommandExecuted();
		}

	}
}