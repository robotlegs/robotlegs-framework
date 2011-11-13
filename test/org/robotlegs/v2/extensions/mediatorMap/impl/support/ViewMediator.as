/*
 * Copyright (c) 2009 the original author or authors
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package org.robotlegs.v2.extensions.mediatorMap.impl.support
{
	import org.robotlegs.mvcs.Mediator;
	
	public class ViewMediator extends Mediator
	{
		[Inject]
		public var view:ViewComponent;
		
		[Inject(name='registered')]
		public var registeredMediators:Array;

		[Inject(name='removed')]
		public var removedMediators:Array;

		
		public function ViewMediator()
		{
		}
		
		override public function onRegister():void
		{
			registeredMediators.push(this);
		}
		
		override public function onRemove():void
		{
			removedMediators.push(this);
		}
	}
}