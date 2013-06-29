//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework
{
	import robotlegs.bender.framework.impl.ApplyHooksTest;
	import robotlegs.bender.framework.impl.ConfigManagerTest;
	import robotlegs.bender.framework.impl.ContextTest;
	import robotlegs.bender.framework.impl.ExtensionInstallerTest;
	import robotlegs.bender.framework.impl.GuardsApproveTest;
	import robotlegs.bender.framework.impl.LifecycleTest;
	import robotlegs.bender.framework.impl.LifecycleTransitionTest;
	import robotlegs.bender.framework.impl.LogManagerTest;
	import robotlegs.bender.framework.impl.LoggerTest;
	import robotlegs.bender.framework.impl.MessageDispatcherTest;
	import robotlegs.bender.framework.impl.ObjectProcessorTest;
	import robotlegs.bender.framework.impl.PinTest;
	import robotlegs.bender.framework.impl.RobotlegsInjectorTest;
	import robotlegs.bender.framework.impl.SafelyCallBackTest;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class FrameworkTestSuite
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		public var applyHooks:ApplyHooksTest;

		public var configManager:ConfigManagerTest;

		public var context:ContextTest;

		public var extensionInstaller:ExtensionInstallerTest;

		public var guardsApprove:GuardsApproveTest;

		public var lifecycle:LifecycleTest;

		public var lifecycleTransition:LifecycleTransitionTest;

		public var logger:LoggerTest;

		public var logManager:LogManagerTest;

		public var messageDispatcher:MessageDispatcherTest;

		public var objectProcessor:ObjectProcessorTest;

		public var pin:PinTest;

		public var robotlegsInjector:RobotlegsInjectorTest;

		public var safelyCallBack:SafelyCallBackTest;
	}
}
