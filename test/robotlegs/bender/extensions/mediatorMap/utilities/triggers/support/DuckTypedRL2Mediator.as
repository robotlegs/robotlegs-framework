//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.utilities.triggers.support
{

	public class DuckTypedRL2Mediator
	{

		public function DuckTypedRL2Mediator()
		{
			super();
		}

		public function initialize():void
		{

		}

		public function destroy():void
		{

		}

		public function setViewComponent(value:Object):void
		{

		}

		protected var _destroyed:Boolean;

		public function get destroyed():Boolean
		{
			return _destroyed;
		}

		public function set destroyed(value:Boolean):void
		{
			if (value !== _destroyed)
			{
				_destroyed = value;
			}
		}
	}
}