//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.api
{
	import org.swiftsuspenders.Injector;

	public interface IMediatorFactory
	{
		function get injector():Injector;

		function createMediator(view:Object, mapping:IMediatorMapping):Object;
	}
}
