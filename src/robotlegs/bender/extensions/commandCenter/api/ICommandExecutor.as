//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.api
{
	import robotlegs.bender.extensions.commandCenter.impl.CommandPayloadConfig;

	public interface ICommandExecutor
	{
		function execute(mappings:Vector.<ICommandMapping>, payload : CommandPayloadConfig = null):void;
	}
}
