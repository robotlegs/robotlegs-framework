//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl
{
	import org.robotlegs.core.IMediatorMap;
	import flash.display.DisplayObjectContainer;
	import org.robotlegs.core.IMediator;
	import robotlegs.bender.extensions.mediatorMap.impl.MediatorMap;
	import flash.display.DisplayObject;
	import robotlegs.bender.core.impl.TypeMatcher;
	import flash.utils.getDefinitionByName;

	public class RL1MediatorMapAdapter implements IMediatorMap
	{
		[Inject]
		public var _mediatorMap:MediatorMap;

		private var _contextView:DisplayObjectContainer;

		private const DISABLE_NOT_SUPPORTED_ERROR:String =
			"You cannot disable this MediatorMap by using the enabled property."+
			" Instead you need to disable the version 2 mediator map that supports this adapter.";

		private const AUTO_CREATE_AUTO_REMOVE_FALSE_NOT_SUPPORTED_ERROR:String =
			"The Robotlegs 1 MediatorMap adapter does not support setting autoCreate or autoRemove to false.";

		private const MANUAL_REGISTRATION_NOT_SUPPORTED_ERROR:String =
			"The RL1MediatorMapAdapter doesn't support manually registering a mediator for a view."+
			" Instead, map the mediator and use createMediator(viewComponent)";

		private const MANUAL_REMOVAL_NOT_SUPPORTED_ERROR:String =
			"The RL1MediatorMapAdapter doesn't support manually removing a mediator.";

		private const AMBIGUOUS_MEDIATOR_ERROR:String =
			"This view has more than one mediator, so the map could not resolve which one you wanted.";

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
			return true;
		}

		public function set enabled(value:Boolean):void
		{
			if(!value)
				throw new ArgumentError(DISABLE_NOT_SUPPORTED_ERROR);
		}

		public function mapView(viewClassOrName:*, mediatorClass:Class, injectViewAs:* = null,
										autoCreate:Boolean = true, autoRemove:Boolean = true):void
		{
			if(!(autoCreate && autoRemove))
				throw new ArgumentError(AUTO_CREATE_AUTO_REMOVE_FALSE_NOT_SUPPORTED_ERROR);

			const viewClass:Class = turnViewClassOrNameToClass(viewClassOrName);

			const matcher:TypeMatcher = new TypeMatcher().allOf(viewClass);

			if(	injectViewAs && (injectViewAs != viewClassOrName))
			{
				if( isArrayOrClassVector(injectViewAs) && (injectViewAs.indexOf(viewClass) > -1) )
				{
					injectViewAs.splice(injectViewAs.indexOf(viewClass), 1);
				}
				matcher.anyOf(injectViewAs);
			}

			_mediatorMap.mapMatcher(matcher).toMediator(mediatorClass);

			mediateContextViewImmediately(viewClass);
		}

		public function unmapView(viewClassOrName:*):void
		{
			const viewClass:Class = turnViewClassOrNameToClass(viewClassOrName);
			_mediatorMap.unmap(viewClass).fromAll();
		}

		public function createMediator(viewComponent:Object):IMediator
		{
			_mediatorMap.mediate(viewComponent as DisplayObject);
			return retrieveMediator(viewComponent);
		}

		public function registerMediator(viewComponent:Object, mediator:IMediator):void
		{
			throw new Error(MANUAL_REGISTRATION_NOT_SUPPORTED_ERROR);
		}

		public function removeMediator(mediator:IMediator):IMediator
		{
			throw new Error(MANUAL_REMOVAL_NOT_SUPPORTED_ERROR);
			return null;
		}

		public function removeMediatorByView(viewComponent:Object):IMediator
		{
			const mediator:IMediator = retrieveMediator(viewComponent);
			_mediatorMap.unmediate(viewComponent as DisplayObject);
			return mediator;
		}

		public function retrieveMediator(viewComponent:Object):IMediator
		{
			const mediators:Array = _mediatorMap.getMediatorsForView(viewComponent as DisplayObject)

			if(!mediators)
				return null;

			if(mediators.length == 1)
				return mediators[0] as IMediator;

			if(mediators.length > 1)
				throw new Error(AMBIGUOUS_MEDIATOR_ERROR);

			return null;
		}

		public function hasMapping(viewClassOrName:*):Boolean
		{
			const viewClass:Class = turnViewClassOrNameToClass(viewClassOrName);
			return _mediatorMap.hasMapping(viewClass);
		}

		public function hasMediator(mediator:IMediator):Boolean
		{
			return _mediatorMap.hasLiveMediator(mediator);
		}

		public function hasMediatorForView(viewComponent:Object):Boolean
		{
			return (_mediatorMap.getMediatorsForView(viewComponent as DisplayObject) != null);
		}

		private function turnViewClassOrNameToClass(viewClassOrName:*):Class
		{
			if(viewClassOrName is Class)
				return viewClassOrName;

			return getDefinitionByName(viewClassOrName) as Class;
		}

		private function mediateContextViewImmediately(viewClass:Class):void
		{
			if(	_contextView && (_contextView is viewClass))
				_mediatorMap.processView(_contextView, null);
		}

		private function isArrayOrClassVector(item:*):Boolean
		{
			if(item is Array || item is Vector.<Class>)
				return true;

			return false;
		}
	}
}