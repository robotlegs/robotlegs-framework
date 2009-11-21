/*
 * Copyright (c) 2009 the original author or authors
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package org.robotlegs.mvcs.support
{
	import org.robotlegs.mvcs.Mediator;
	
	public class ViewMediator extends Mediator
	{
		[Inject]
		public var view:ViewComponent;
		
		public function ViewMediator()
		{
		}
		
		override public function onRegister():void
		{
		
		}
		
		override public function onRemove():void
		{
		
		}
	}
}