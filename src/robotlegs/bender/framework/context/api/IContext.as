//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.context.api
{
	import org.hamcrest.Matcher;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.framework.logging.api.ILogTarget;
	import robotlegs.bender.framework.logging.api.ILogger;
	import robotlegs.bender.framework.object.managed.api.IManagedObject;

	public interface IContext extends Matcher
	{
		function get injector():Injector;

		function get initializing():Boolean;

		function get initialized():Boolean;

		function get destroying():Boolean;

		function get destroyed():Boolean;

		function get logLevel():uint;

		function set logLevel(value:uint):void;

		function initialize():void;

		function destroy():void;

		function require(... configs):IContext;

		function addConfigHandler(matcher:Matcher, handler:Function):IContext;

		function addObject(object:Object):IContext;

		function addObjectHandler(matcher:Matcher, handler:Function):IContext;

		function getManagedObject(object:Object):IManagedObject;

		function addStateHandler(step:String, handler:Function):IContext;

		function removeStateHandler(step:String, handler:Function):IContext;

		function getLogger(source:Object):ILogger;

		function addLogTarget(target:ILogTarget):void;
	}
}
