//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.core.impl.support
{
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;
	import flash.system.ApplicationDomain;
	
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.api.IContextLogger;
	import org.robotlegs.v2.core.impl.ContextLogger;
	import org.swiftsuspenders.Injector;

	public class NullContext implements IContext
	{

		protected var _injector:Injector;

		public function get injector():Injector
		{
			return _injector;
		}

		public function set injector(value:Injector):void
		{
			_injector = value;
		}

		private var _logger:IContextLogger;

		public function get logger():IContextLogger
		{
			return _logger;
		}

		public function get id():String
		{
			return null;
		}

		public function get applicationDomain():ApplicationDomain
		{
			return null;
		}

		public function get contextView():DisplayObjectContainer
		{
			return null;
		}

		public function set contextView(value:DisplayObjectContainer):void
		{
		}

		public function get destroyed():Boolean
		{
			return false;
		}

		public function get dispatcher():IEventDispatcher
		{
			return null;
		}

		public function set dispatcher(value:IEventDispatcher):void
		{
		}

		public function get initialized():Boolean
		{
			return false;
		}

		public function get parent():IContext
		{
			return null;
		}

		public function set parent(value:IContext):void
		{
		}

		public function NullContext()
		{
			_logger = new ContextLogger(this);
		}

		public function destroy():void
		{
		}

		public function initialize(callback:Function):void
		{
		}

		public function installExtension(extensionClass:Class):IContext
		{
			return null;
		}

		public function uninstallExtension(extensionClass:Class):IContext
		{
			return null;
		}

		public function withConfig(configClass:Class):IContext
		{
			return null;
		}
	}
}
