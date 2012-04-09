//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.api
{
	import flash.events.IEventDispatcher;

	[Event(name="mediatorCreate", type="robotlegs.bender.extensions.mediatorMap.api.MediatorFactoryEvent")]
	[Event(name="mediatorRemove", type="robotlegs.bender.extensions.mediatorMap.api.MediatorFactoryEvent")]
	public interface IMediatorFactory extends IEventDispatcher
	{
		function createMediator(view:Object, mapping:IMediatorMapping):Object;

		function getMediator(view:Object, mapping:IMediatorMapping):Object;

		function removeMediator(view:Object, mapping:IMediatorMapping):void;
	}
}
