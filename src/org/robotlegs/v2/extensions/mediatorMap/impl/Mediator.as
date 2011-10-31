//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap.impl
{
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediator;
	
	public class Mediator implements IMediator
	{

		protected var _viewComponent:Object;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function Mediator()
		{
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

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

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/
		
		protected function onRegister():void
		{
			
		}
		
		protected function onRemove():void
		{
			
		}
	}
}