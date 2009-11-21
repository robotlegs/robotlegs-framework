/*
 * Copyright (c) 2009 the original author or authors
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.robotlegs.mvcs.support
{
	import flash.events.Event;
	
	import org.robotlegs.mvcs.Actor;
	import org.robotlegs.mvcs.ActorTests;

	public class TestActor extends Actor
	{
		public function TestActor()
		{
			super();
		}

		public function dispatchTestEvent():void
		{
			eventDispatcher.dispatchEvent(new Event(ActorTests.TEST_EVENT));
		}
	}
}