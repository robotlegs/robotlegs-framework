//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package suites
{
	import org.robotlegs.v2.experimental.CommandFlowTest;
	import org.robotlegs.v2.experimental.CommandFlowRuleTest;
	import org.robotlegs.v2.experimental.CommandFlow_sequenceTest;
	import org.robotlegs.v2.experimental.CommandFlowMappingTest;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class CommandFlowTestSuite
	{

		public var commandFlowTests:CommandFlowTest;
		
		public var commandFlowRuleTest:CommandFlowRuleTest;
		
		public var commandFlow_sequenceTest:CommandFlow_sequenceTest;
		
		public var commandFlowMappingTest:CommandFlowMappingTest;
	}
}