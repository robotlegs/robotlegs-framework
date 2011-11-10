//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.core.api
{
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;
	import org.swiftsuspenders.Injector;

	[Event(name="contextBuildComplete", type="org.robotlegs.v2.core.api.ContextBuilderEvent")]
	public interface IContextBuilder extends IEventDispatcher
	{
		function build():IContext;

		/**
		 * Installs a builder bundle
		 * @param bundleClass a class that implements IContextBuilderBundle
		 * @return builder
		 */
		function withBundle(bundleClass:Class):IContextBuilder;

		/**
		 * Install a context config
		 * @param configClass a class that implements IContextConfig
		 * @return builder
		 */
		function withConfig(configClass:Class):IContextBuilder;

		function withContextView(value:DisplayObjectContainer):IContextBuilder;

		function withDispatcher(value:IEventDispatcher):IContextBuilder;

		/**
		 * Installs a context runtime extension
		 * @param extensionClass a class that implements IContextExtension
		 * @return builder
		 */
		function withExtension(extensionClass:Class):IContextBuilder;

		function withInjector(value:Injector):IContextBuilder;

		function withParent(value:IContext):IContextBuilder;

		/**
		 * Installs a context pre-processor
		 * @param preProcessorClass a class that implements IContextPreProcessor
		 * @return builder
		 */
		function withPreProcessor(preProcessorClass:Class):IContextBuilder;

		function withLogTarget(target:ILogTarget):IContextBuilder;
	}
}
