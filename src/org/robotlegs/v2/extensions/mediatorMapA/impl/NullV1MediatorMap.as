//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMapA.impl
{
	import org.robotlegs.core.IMediatorMap;
	import org.robotlegs.core.IMediator;
	import flash.display.DisplayObjectContainer;

	[Deprecated(message="This should not be needed. We can make v1 work with v2")]
	public class NullV1MediatorMap implements IMediatorMap
	{
		protected static const UNSUPPORTED_V1_FEATURE:String = "While version 1 Robotlegs Mediators are supported in the version 2 MediatorMap, the version 1 IMediatorMap injected in to them is a null implementation and cannot be used. If you need to use a mediator map in your mediator, inject the version 2 IMediatorMap.";

		//---------------------------------------
		// Null IMediatorMap Implementation
		//---------------------------------------

		
		public function get contextView():DisplayObjectContainer
		{
			throwNullImplementationError();
			return null;
		}

		public function set contextView(value:DisplayObjectContainer):void
		{
			throwNullImplementationError();
		}

		public function get enabled():Boolean
		{
			throwNullImplementationError();
			return false;
		}

		public function set enabled(value:Boolean):void
		{
			throwNullImplementationError();
		}

		public function mapView(viewClassOrName:*, mediatorClass:Class, injectViewAs:* = null, autoCreate:Boolean = true, autoRemove:Boolean = true):void
		{
			throwNullImplementationError();
		}

		public function unmapView(viewClassOrName:*):void
		{
			throwNullImplementationError();
		}

		public function createMediator(viewComponent:Object):IMediator
		{
			throwNullImplementationError();
			return null;
		}

		public function registerMediator(viewComponent:Object, mediator:IMediator):void
		{
			throwNullImplementationError();
		}

		public function removeMediator(mediator:IMediator):IMediator
		{
			throwNullImplementationError();
			return null;
		}

		public function removeMediatorByView(viewComponent:Object):IMediator
		{
			throwNullImplementationError();
			return null;
		}

		public function retrieveMediator(viewComponent:Object):IMediator
		{
			throwNullImplementationError();
			return null;
		}

		public function hasMapping(viewClassOrName:*):Boolean
		{
			throwNullImplementationError();
			return false;
		}

		public function hasMediator(mediator:IMediator):Boolean
		{
			throwNullImplementationError();
			return false;
		}

		public function hasMediatorForView(viewComponent:Object):Boolean
		{
			throwNullImplementationError();
			return false;
		}
		
		protected function throwNullImplementationError():void
		{
			throw new Error(UNSUPPORTED_V1_FEATURE);
		}
	}

}