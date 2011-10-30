//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.commandMap
{
	import org.hamcrest.assertThat;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;
	import org.hamcrest.object.notNullValue;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandMap;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandMapping;
	import org.robotlegs.v2.extensions.commandMap.impl.CommandMap;
	import org.swiftsuspenders.Injector;

	public class CommandMapTests
	{

		private var commandMap:ICommandMap;

		private var injector:Injector;

		[Before]
		public function setUp():void
		{
			injector = new Injector();
			commandMap = new CommandMap();
		}

		[After]
		public function tearDown():void
		{
			injector = null;
			commandMap = null;
		}

		[Test]
		public function mapCreatesMapping():void
		{
			const mapping:ICommandMapping = commandMap.map(TestCommand);
			assertThat(mapping, notNullValue());
		}

		[Test]
		public function mapStoresMapping():void
		{
			assertThat(commandMap.hasMapping(TestCommand), isFalse());
			commandMap.map(TestCommand);
			assertThat(commandMap.hasMapping(TestCommand), isTrue());
		}

		[Test]
		public function unmapRemovesMapping():void
		{
			commandMap.map(TestCommand);
			assertThat(commandMap.hasMapping(TestCommand), isTrue());
			commandMap.unmap(TestCommand);
			assertThat(commandMap.hasMapping(TestCommand), isFalse());
		}
	}
}

class TestCommand
{
	public function execute():void
	{

	}
}
