//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap.impl
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import org.robotlegs.v2.core.api.ITypeFilter;
	import org.robotlegs.v2.extensions.viewManager.api.IViewClassInfo;
	import org.robotlegs.v2.extensions.viewManager.api.IViewHandler;
	import org.robotlegs.v2.extensions.viewManager.api.ViewHandlerEvent;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediatorMap;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediatorMapping;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediatorTrigger;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediatorUnmapping;
	import org.swiftsuspenders.Injector;
	import flash.errors.IllegalOperationError;
	import org.robotlegs.v2.extensions.viewManager.api.ViewInterests;
	import org.robotlegs.v2.core.api.ITypeMatcher;
	import org.robotlegs.v2.core.impl.TypeMatcher;
	import org.robotlegs.v2.extensions.viewMap.impl.ViewMap;

	[Event(name="configurationChange", type="org.robotlegs.v2.extensions.viewManager.api.ViewHandlerEvent")]
	public class MediatorMap extends EventDispatcher implements IViewHandler, IMediatorMap
	{
		[Inject]
		public var injector:Injector;
		
		public function get interests():uint
		{
			return ViewInterests.MEDIATION;
		}

		[Inject]
		public function set viewMap(value:ViewMap):void
		{
			_viewMap = value;
			_viewMap.processCallback = processMapping;
		}

		private const _liveMediatorsByView:Dictionary = new Dictionary();

		private const _viewsInRemovalPhase:Dictionary = new Dictionary();

		private var _trigger:IMediatorTrigger;
		
		private var _viewMap:ViewMap;
		
		/* 			public 			*/

		public function getMapping(viewTypeOrMatcher:*):IMediatorMapping
		{
			return _viewMap.getMapping(viewTypeOrMatcher) as IMediatorMapping;
		}
		
		public function hasMapping(viewTypeOrMatcher:*):Boolean
		{
			return _viewMap.hasMapping(viewTypeOrMatcher);
		}
		
		public function processView(view:DisplayObject, info:IViewClassInfo):uint
		{
			if(_viewMap.processView(view, info))
				return 1;

			return 0;
		}
		
		public function releaseView(view:DisplayObject):void
		{
			if (!_liveMediatorsByView[view])
				return;
				
			if (!view.parent)
			{
				actionRemoval(view);
			}
			else
			{
				_viewsInRemovalPhase[view] = view;
				view.addEventListener(Event.ENTER_FRAME, onEnterFrameActionShutdown);
			}
		}

		public function invalidate():void
		{
			dispatchEvent(new ViewHandlerEvent(ViewHandlerEvent.HANDLER_CONFIGURATION_CHANGE));
		}

		public function map(viewType:Class):IMediatorMapping
		{
			return mapMatcher(new TypeMatcher().allOf(viewType));
		}
		
		public function mapMatcher(typeMatcher:ITypeMatcher):IMediatorMapping
		{
			var mapping:IMediatorMapping;
			
			if(_viewMap.hasMapping(typeMatcher))
			{
				return _viewMap.getMapping(typeMatcher) as IMediatorMapping;
			}

			const typeFilter:ITypeFilter = _viewMap.getOrCreateFilterForMatcher(typeMatcher);
			mapping = createMapping(typeFilter);
			_viewMap.createMapping(typeFilter, mapping);			
			return mapping;
		}

		public function unmap(viewType:Class):IMediatorUnmapping
		{
			return unmapMatcher(new TypeMatcher().allOf(viewType));
		} 
		
		public function unmapMatcher(typeMatcher:ITypeMatcher):IMediatorUnmapping
		{
			return _viewMap.getMapping(typeMatcher) as IMediatorUnmapping;
		}

		public function loadTrigger(trigger:IMediatorTrigger):void
		{
			if(_trigger)
			{
				throw new IllegalOperationError("The trigger has already been set to " + _trigger + " and can only be set once.");
			}
			_trigger = trigger;
		}

		public function mediate(view:DisplayObject):Boolean
		{
			return (processView(view, null) > 0);
		}

		public function unmediate(view:DisplayObject):void
		{
			releaseView(view);
		}

		public function destroy():void
		{
		}
		
		/*			INTERNAL		*/
		
		internal function getMediatorsForView(view:DisplayObject):Array
		{
			return _liveMediatorsByView[view];
		}
		
		internal function hasLiveMediator(mediator:Object):Boolean
		{
			for each (var mediators:Array in _liveMediatorsByView)
			{
				if(mediators.indexOf(mediator) > -1)
				{
					return true;
				}
			}
			
			return false;
		}

		/*        PRIVATE        */
		
		// TODO = check _liveMediatorsByView for this view, exit / error if it would overwrite
		// TODO - probably refactor to a linked list for iteration
		private function processMapping(view:DisplayObject, info:IViewClassInfo, filter:ITypeFilter, mapping:MediatorMapping):void
		{
			if (_liveMediatorsByView[view] && _viewsInRemovalPhase[view])
			{
				view.removeEventListener(Event.ENTER_FRAME, onEnterFrameActionShutdown);
				delete _viewsInRemovalPhase[view];
				return;
			}

			_viewMap.mapViewForFilterBinding(filter, info, view);

			var configsByMediator:Dictionary = mapping.configsByMediator;

			for(var mediator:* in configsByMediator)
			{
				processConfig(mediator, configsByMediator[mediator], view);
			}

			_viewMap.unmapViewForFilterBinding(filter, info, view);
		}
		
		private function onEnterFrameActionShutdown(e:Event):void
		{
			e.target.removeEventListener(Event.ENTER_FRAME, onEnterFrameActionShutdown);
			const view:DisplayObject = e.target as DisplayObject;
			actionRemoval(view);
			delete _viewsInRemovalPhase[view];
		}

		private function actionRemoval(view:DisplayObject):void
		{
			for each (var mediator:* in _liveMediatorsByView[view])
			{
				_trigger.shutdown(mediator, view, cleanUpMediator);
			}
		}

		private function createMediator(mediatorType:Class):*
		{
			const mediator:* = injector.getInstance(mediatorType);
			injector.map(mediatorType).toValue(mediator);
			return mediator;
		}

		private function createMapping(typeFilter:ITypeFilter):IMediatorMapping
		{
			return new MediatorMapping(cleanUpMapping, typeFilter, injector);
		}

		private function processConfig(mediatorType:Class, config:MediatorConfig, view:DisplayObject):void
		{
			if(config.guards.approve())
			{
				const mediator:* = createMediator(mediatorType);
				config.hooks.hook();
				injector.unmap(mediatorType);

				if (!_liveMediatorsByView[view])
					_liveMediatorsByView[view] = [];

				_liveMediatorsByView[view].push(mediator);

				_trigger.startup(mediator, view);
			}
		}

		private function cleanUpMediator(mediator:*, view:DisplayObject):void
		{
			if (!_viewsInRemovalPhase[view])
				return;

			const index:int = _liveMediatorsByView[view].indexOf(mediator);

			if (index > -1)
				_liveMediatorsByView[view].splice(index, 1);
		}

		private function cleanUpMapping(typeFilter:ITypeFilter):void
		{
			_viewMap.removeMapping(typeFilter);
		}
	}
}