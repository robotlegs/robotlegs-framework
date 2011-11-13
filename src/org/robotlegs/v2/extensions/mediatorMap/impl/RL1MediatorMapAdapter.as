//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap.impl
{
	import org.robotlegs.core.IMediatorMap;
	import flash.display.DisplayObjectContainer;
	import org.robotlegs.core.IMediator;
	import org.robotlegs.v2.extensions.mediatorMap.impl.MediatorMap;
	import flash.display.DisplayObject;
	import org.robotlegs.v2.core.impl.TypeMatcher;
	
	public class RL1MediatorMapAdapter implements IMediatorMap
	{
		[Inject]
		public var _mediatorMap:MediatorMap;
		
		private var _contextView:DisplayObjectContainer;
		
		/* 	Provides an adapter to allow RL1 Mediators and Commands to have a 
			RL1 IMediatorMap injected into them. Some features not supported. */

		public function RL1MediatorMapAdapter()
		{
		}
		
		public function get contextView():DisplayObjectContainer
		{
			return _contextView;
		}

		[Inject]
		public function set contextView(value:DisplayObjectContainer):void
		{
			_contextView = value;
		}

		public function get enabled():Boolean
		{
			return false;
		}

		public function set enabled(value:Boolean):void
		{
			
		}

		public function mapView(viewClassOrName:*, mediatorClass:Class, injectViewAs:* = null, autoCreate:Boolean = true, autoRemove:Boolean = true):void
		{
			if(!(autoCreate && autoRemove))
			{
				throw new ArgumentError('The Robotlegs 1 MediatorMap adapter does not support setting autoCreate or autoRemove to false.');
			}
			
			// TODO check when string used and convert to class
			
			const matcher:TypeMatcher = new TypeMatcher().allOf(viewClassOrName);
						
			if(injectViewAs && (injectViewAs != viewClassOrName))
			{
				if( ( (injectViewAs is Array) || (injectViewAs is Vector.<Class>) )
				 	&& (injectViewAs.indexOf(viewClassOrName) > -1) )
				{
					injectViewAs.splice(injectViewAs.indexOf(viewClassOrName), 1);
				}
				matcher.anyOf(injectViewAs);
			}

			_mediatorMap.mapMatcher(matcher).toMediator(mediatorClass);
			
			// TODO - remove explicit stage check as can throw SecurityError in Air
			if(	_contextView 
				&& _contextView.stage 
				&& (viewClassOrName is Class) 
				&& (_contextView is viewClassOrName))
			{
				_mediatorMap.processView(_contextView, null);
			}
		}

		public function unmapView(viewClassOrName:*):void
		{
			_mediatorMap.unmap(viewClassOrName).fromAll();
		}

		public function createMediator(viewComponent:Object):IMediator
		{
			_mediatorMap.mediate(viewComponent as DisplayObject);
			return null;
		}

		public function registerMediator(viewComponent:Object, mediator:IMediator):void
		{
			
		}

		public function removeMediator(mediator:IMediator):IMediator
		{
			return null;
		}

		public function removeMediatorByView(viewComponent:Object):IMediator
		{
			_mediatorMap.unmediate(viewComponent as DisplayObject);
			return null;
		}

		public function retrieveMediator(viewComponent:Object):IMediator
		{
			return null;
		}

		public function hasMapping(viewClassOrName:*):Boolean
		{
			return _mediatorMap.hasMapping(viewClassOrName);
		}

		public function hasMediator(mediator:IMediator):Boolean
		{
			return false;
		}

		public function hasMediatorForView(viewComponent:Object):Boolean
		{
			return false;
		}
	}
}