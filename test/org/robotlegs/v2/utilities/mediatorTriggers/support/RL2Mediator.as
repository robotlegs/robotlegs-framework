//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.utilities.mediatorTriggers.support
{
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediator;

	public class RL2Mediator implements IMediator
	{

		private var _robotlegs_view:Object;

		public function RL2Mediator()
		{
			super();
		}

		//---------------------------------------
		// IMediator Implementation
		//---------------------------------------

		//import org.robotlegs.v2.extensions.mediatorMap.api.IMediator;
		public function preRegister():void
		{

		}

		public function onRegister():void
		{

		}

		public function preRemove():void
		{

		}

		public function onRemove():void
		{

		}

		public function getViewComponent():Object
		{
			return _robotlegs_view;
		}

		public function setViewComponent(viewComponent:Object):void
		{
			_robotlegs_view = viewComponent;
		}
	}

}
