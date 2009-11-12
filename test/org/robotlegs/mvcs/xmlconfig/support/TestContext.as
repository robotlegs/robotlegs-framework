/*
 * Copyright (c) 2009 the original author or authors
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.robotlegs.mvcs.xmlconfig.support
{
	import flash.display.DisplayObjectContainer;
	
	import org.robotlegs.adapters.SwiftSuspendersInjector;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.mvcs.support.TestContext;
	
	public class TestContext extends org.robotlegs.mvcs.support.TestContext
	{
		public function TestContext(contextView:DisplayObjectContainer = null, autoStartup:Boolean = true)
		{
			super(contextView, autoStartup);
		}
		
		override protected function get injector():IInjector
		{
			return _injector || (_injector = new SwiftSuspendersInjector());
		}
	}
}