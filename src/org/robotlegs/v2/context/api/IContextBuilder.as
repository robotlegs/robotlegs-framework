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
	import org.robotlegs.core.IInjector;

	[Event(name="contextBuildComplete", type="org.robotlegs.v2.context.api.ContextBuilderEvent")]
	public interface IContextBuilder extends IEventDispatcher
	{
		function build():IContext;

		function installConfig(config:IContextBuilderConfig):IContextBuilder;

		function installProcessor(processor:IContextProcessor):IContextBuilder;

		function installUtility(clazz:Class, injectAs:Class = null, named:String = ''):IContextBuilder;

		function withContextView(value:DisplayObjectContainer):IContextBuilder;

		function withDispatcher(value:IEventDispatcher):IContextBuilder;

		function withInjector(value:IInjector):IContextBuilder;

		function withParent(value:IContext):IContextBuilder;
	}
}
