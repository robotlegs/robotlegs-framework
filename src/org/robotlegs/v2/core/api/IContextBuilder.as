//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.core.api
{
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;
	import org.robotlegs.core.IInjector;

	[Event(name="contextBuildComplete", type="org.robotlegs.v2.core.api.ContextBuilderEvent")]
	public interface IContextBuilder extends IEventDispatcher
	{
		function build():IContext;

		function withBundle(bundle:IContextBuilderBundle):IContextBuilder;

		function withConfig(configClass:Class):IContextBuilder;

		function withContextView(value:DisplayObjectContainer):IContextBuilder;

		function withDispatcher(value:IEventDispatcher):IContextBuilder;

		function withExtension(extension:IContextExtension):IContextBuilder;

		function withInjector(value:IInjector):IContextBuilder;

		function withParent(value:IContext):IContextBuilder;

		function withProcessor(processor:IContextProcessor):IContextBuilder;
	}
}
