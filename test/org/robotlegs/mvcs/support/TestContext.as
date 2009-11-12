/*
 * Copyright (c) 2009 the original author or authors
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.robotlegs.mvcs.support
{
	import flash.display.DisplayObjectContainer;
	
	import org.robotlegs.core.IInjector;
	import org.robotlegs.mvcs.Context;
	
	public class TestContext extends Context
	{
		public var startupComplete:Boolean = false;
		
		public function TestContext(contextView:DisplayObjectContainer = null, autoStartup:Boolean = true)
		{
			super(contextView, autoStartup);
		}
		
		override public function startup():void
		{
			startupComplete = true;
			super.startup();
		}
		
		public function getInjector():IInjector
		{
			return this.injector;
		}
		
		public function get isInitialized():Boolean
		{
			var initialized:Boolean = true;
			initialized = commandMap && initialized;
			initialized = mediatorMap && initialized;
			return initialized;
		
		}
	}
}