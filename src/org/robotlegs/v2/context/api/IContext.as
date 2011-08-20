//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.context.api
{
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;
	import org.swiftsuspenders.v2.dsl.IInjector;

	public interface IContext
	{

		function get contextView():DisplayObjectContainer;
		function set contextView(value:DisplayObjectContainer):void;

		function get dispatcher():IEventDispatcher;
		function set dispatcher(value:IEventDispatcher):void;

		function get initialized():Boolean;

		function get injector():IInjector;
		function set injector(value:IInjector):void;

		function get parent():IContext;
		function set parent(value:IContext):void;

		function initialize():void;
	}
}
