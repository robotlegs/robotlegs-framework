//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.experimental 
{
	import org.flexunit.asserts.*;
	import org.robotlegs.v2.experimental.CommandFlowStart;
	import org.robotlegs.v2.experimental.ICommandFlowRule;
	import flash.events.IEventDispatcher;
	import flash.events.EventDispatcher;

	public class CommandFlowMappingTest 
	{
		private var instance:CommandFlowMapping;
		
		private const FROM:Vector.<Class> = new <Class>[CommandFlowStart];
		
		private var eventDispatcher:IEventDispatcher;

		[Before]
		public function setUp():void
		{
			eventDispatcher = new EventDispatcher();
			instance = new CommandFlowMapping(FROM, eventDispatcher, callback, true);
		}

		[After]
		public function tearDown():void
		{
			instance = null;
		}

		[Test]
		public function can_be_instantiated():void
		{
			assertTrue("instance is CommandFlowMapping", instance is CommandFlowMapping);
		}

		[Test]
		public function test_failure_seen():void
		{
			assertTrue("Failing test", true);
		}
		
		[Test]
		public function test_get_from():void {
			assertEquals("Get from", FROM, instance.from);
		}
		
		protected function callback(rule:ICommandFlowRule):void
		{
			
		}

	}
}