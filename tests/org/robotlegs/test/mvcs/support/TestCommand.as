package org.robotlegs.test.mvcs.support
{
	import org.robotlegs.core.ICommand;
	import org.robotlegs.test.mvcs.CommandFactoryTests;
	
	public class TestCommand implements ICommand
	{
		[Inject]
		public var testSuite:CommandFactoryTests;
		
		public function execute():void
		{
			testSuite.markCommandExecuted();
		}
	
	}
}