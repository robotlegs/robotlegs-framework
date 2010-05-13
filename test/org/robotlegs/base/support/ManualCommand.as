/*
 * Copyright (c) 2010 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package org.robotlegs.base.support
{
	import org.robotlegs.mvcs.support.ICommandTest;
	
	public class ManualCommand
	{
		[Inject]
		public var testSuite:ICommandTest;
		
		[Inject]
		public var payload:Object;
		
		public function execute():void
		{
			testSuite.markCommandExecuted();
		}
	}
}