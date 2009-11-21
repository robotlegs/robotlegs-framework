/*
 * Copyright (c) 2009 the original author or authors
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */
package org.robotlegs.mvcs
{
	import flexunit.framework.Assert;
	import org.robotlegs.mvcs.Mediator;
	import org.robotlegs.core.IEventMap;
	
	/**
	 * Extends Mediator in order to test protected APIs.
	 */
	public class MediatorProtectedTests extends Mediator
	{
		/**
		 * Exposed a bug with the lazy getter where a new EventMap was being created each time.
		 */
		[Test]
		public function retrievingEventMapTwiceShouldYieldSameObject():void
		{
			Assert.assertEquals(this.eventMap, this.eventMap);
		}
		
	}
}
