//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.support
{
	import mockolate.nice;
	import mockolate.stub;

	import robotlegs.bender.extensions.commandCenter.api.ICommandExecutor;

	import robotlegs.bender.extensions.commandCenter.api.ICommandMapper;
	import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;

	/**
	 * Used for function stubbing
	 */
	public class CommandMapStub
	{

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function keyFactory(... params):String
		{
			return params.join("::");
		}

		public function triggerFactory(... params):ICommandTrigger
		{
			const trigger:ICommandTrigger = nice(ICommandTrigger);
			stub(trigger).getter("executor").returns(nice(ICommandExecutor));
			return trigger;
		}

		public function mapperFactory(... params):ICommandMapper
		{
			return nice(ICommandMapper);
		}

		public function hook(...params):void
		{
		}
	}
}
