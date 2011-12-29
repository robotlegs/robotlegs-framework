//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.core.api
{
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	import org.swiftsuspenders.Injector;

	public interface IContext
	{
		function get logger():IContextLogger;

		function get applicationDomain():ApplicationDomain;

		function get contextView():DisplayObjectContainer;
		function set contextView(value:DisplayObjectContainer):void;

		function get destroyed():Boolean;

		function get dispatcher():IEventDispatcher;
		function set dispatcher(value:IEventDispatcher):void;

		function get initialized():Boolean;

		function get injector():Injector;
		function set injector(value:Injector):void;

		function get parent():IContext;
		function set parent(value:IContext):void;

		function destroy():void;

		function initialize(callback:Function):void;

		/**
		 * Install a runtime context extension
		 * @param extensionClass a class that implements IContextExtension
		 * return context
		 */
		function installExtension(extensionClass:Class):IContext;

		/**
		 * Uninstall a runtime context extension
		 * @param extensionClass a class that implements IContextExtension
		 * return context
		 */
		function uninstallExtension(extensionClass:Class):IContext;

		/**
		 * Application config
		 * @param configClass a class that implements IContextConfig
		 * return context
		 */
		function withConfig(configClass:Class):IContext;
	}
}
