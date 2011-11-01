//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap.impl
{
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediator;
	import org.robotlegs.core.IEventMap;
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	public class Mediator implements IMediator
	{
		[Inject]
		public var eventMap:IEventMap;
		
		protected var _viewComponent:Object;
		
		public function Mediator()
		{
		}

		public function preRegister():void
		{
			onRegister();
		}

		public function preRemove():void
		{
			onRemove();
		}

		public function getViewComponent():Object
		{
			return _viewComponent;
		}

		public function setViewComponent(viewComponent:Object):void
		{
			_viewComponent = viewComponent;
		}

		protected function onRegister():void
		{

		}

		protected function onRemove():void
		{

		}
	}
}