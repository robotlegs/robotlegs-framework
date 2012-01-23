//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.configManager.api
{
	import org.hamcrest.Matcher;

	public interface IConfigManager
	{
		function addConfig(config:Object):void;

		function addConfigHandler(matcher:Matcher, handler:Function):void;
	}
}
