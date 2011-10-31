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
	import flash.utils.getQualifiedClassName;
	import org.robotlegs.v2.core.api.ITypeFilter;
	import org.robotlegs.v2.extensions.guards.GuardsProcessor;
	import org.robotlegs.v2.extensions.hooks.HooksProcessor;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediatorConfig;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediatorMap;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediatorMapping;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediatorTrigger;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediatorUnmapping;
	import org.robotlegs.v2.extensions.displayList.api.IViewClassInfo;
	import org.robotlegs.v2.extensions.displayList.api.IViewHandler;
	import org.robotlegs.v2.extensions.displayList.api.IViewWatcher;
	import org.robotlegs.v2.extensions.displayList.api.ViewHandlerEvent;
	import org.swiftsuspenders.Injector;
	import org.swiftsuspenders.Reflector;

	[Event(name="configurationChange", type="org.robotlegs.v2.extensions.displayList.api.ViewHandlerEvent")]
	public class MediatorMap extends EventDispatcher implements IViewHandler, IMediatorMap
	{

		[Inject]
		public var guardsProcessor:GuardsProcessor;

		[Inject]
		public var hooksProcessor:HooksProcessor;

		[Inject]
		public var injector:Injector;

		public function get interests():uint
		{
			return 0;
		}

		[Inject]
		public var reflector:Reflector;

		protected const _configsByTypeFilter:Dictionary = new Dictionary();

		protected const _filtersByDescription:Dictionary = new Dictionary();

		protected const _liveMediatorsByView:Dictionary = new Dictionary();

		protected const _mappingsByMediatorType:Dictionary = new Dictionary();

		protected var _trigger:IMediatorTrigger;

		protected const _viewsInRemovalPhase:Dictionary = new Dictionary();

		public function MediatorMap()
		{

		}

		public function getMapping(mediatorType:Class):IMediatorMapping
		{
			return _mappingsByMediatorType[mediatorType];
		}

		public function handleViewAdded(view:DisplayObject, info:IViewClassInfo):uint
		{
			// TODO = check _liveMediatorsByView for this view, exit / error if it would overwrite

			var interest:uint = 0;

			for (var filter:* in _configsByTypeFilter)
			{
				if ((filter as ITypeFilter).matches(view))
				{
					interest = 1;

					if (_liveMediatorsByView[view] && _viewsInRemovalPhase[view])
					{
						view.removeEventListener(Event.ENTER_FRAME, onEnterFrameActionShutdown);
						delete _viewsInRemovalPhase[view];
						return interest;
					}

					mapViewForFilterBinding(filter, view);

					for each (var config:IMediatorConfig in _configsByTypeFilter[filter])
					{
						processMapping(config, view);
					}

					unmapViewForFilterBinding(filter, view);
				}
			}

			return interest;
		}

		public function handleViewRemoved(view:DisplayObject):void
		{
			if (_liveMediatorsByView[view])
			{
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
		}

		public function hasMapping(mediatorType:Class):Boolean
		{
			return (_mappingsByMediatorType[mediatorType] && _mappingsByMediatorType[mediatorType].hasConfigs);
		}

		public function invalidate():void
		{
			dispatchEvent(new ViewHandlerEvent(ViewHandlerEvent.CONFIGURATION_CHANGE));
		}

		public function map(mediatorType:Class):IMediatorMapping
		{
			if (!_mappingsByMediatorType[mediatorType])
				_mappingsByMediatorType[mediatorType] = createMediatorMapping(mediatorType);

			return _mappingsByMediatorType[mediatorType];
		}

		public function unmap(mediatorType:Class):IMediatorUnmapping
		{
			return _mappingsByMediatorType[mediatorType];
		}

		public function loadTrigger(trigger:IMediatorTrigger):void
		{
			_trigger = trigger;
		}

		public function mediate(view:DisplayObject):Boolean
		{
			return (handleViewAdded(view, null) > 0);
		}

		public function unmediate(view:DisplayObject):void
		{
			handleViewRemoved(view);
		}

		protected function onEnterFrameActionShutdown(e:Event):void
		{
			e.target.removeEventListener(Event.ENTER_FRAME, onEnterFrameActionShutdown);
			const view:DisplayObject = e.target as DisplayObject;
			actionRemoval(view);
			delete _viewsInRemovalPhase[view];
		}

		protected function actionRemoval(view:DisplayObject):void
		{
			for each (var mediator:* in _liveMediatorsByView[view])
			{
				_trigger.shutdown(mediator, view, cleanUpMediator);
			}
		}

		protected function blockedByGuards(guards:Vector.<Class>):Boolean
		{
			return ((guards.length > 0)
				&& !(guardsProcessor.processGuards(injector, guards)))
		}

		protected function createMediatorForBinding(config:IMediatorConfig):*
		{
			const mediator:* = injector.getInstance(config.mapping.mediator);
			injector.map(config.mapping.mediator).toValue(mediator);
			return mediator;
		}

		protected function createMediatorMapping(mediatorType:Class):IMediatorMapping
		{
			return new MediatorMapping(_configsByTypeFilter,
				_filtersByDescription,
				mediatorType,
				cleanUpMapping);
		}

		protected function mapViewForFilterBinding(filter:ITypeFilter, view:DisplayObject):void
		{
			var requiredType:Class;

			for each (requiredType in filter.allOfTypes)
			{
				injector.map(requiredType).toValue(view);
			}

			for each (requiredType in filter.anyOfTypes)
			{
				injector.map(requiredType).toValue(view);
			}
		}

		protected function processMapping(config:IMediatorConfig, view:DisplayObject):void
		{
			if (!blockedByGuards(config.guards))
			{
				const mediator:* = createMediatorForBinding(config);
				hooksProcessor.runHooks(injector, config.hooks);
				injector.unmap(config.mapping.mediator);

				if (!_liveMediatorsByView[view])
					_liveMediatorsByView[view] = [];

				_liveMediatorsByView[view].push(mediator);

				_trigger.startup(mediator, view);
			}
		}

		protected function unmapViewForFilterBinding(filter:ITypeFilter, view:DisplayObject):void
		{
			var requiredType:Class;

			for each (requiredType in filter.allOfTypes)
			{
				injector.unmap(requiredType);
			}

			for each (requiredType in filter.anyOfTypes)
			{
				injector.unmap(requiredType);
			}
		}

		protected function cleanUpMediator(mediator:*, view:DisplayObject):void
		{
			if (!_viewsInRemovalPhase[view])
			{
				return;
			}

			const index:int = _liveMediatorsByView[view].indexOf(mediator);
			if (index > -1)
			{
				_liveMediatorsByView[view].splice(index, 1);
			}
		}

		protected function cleanUpMapping(mediatorType:Class):void
		{
			trace("MediatorMap::cleanUpMapping()", mediatorType);
			delete _mappingsByMediatorType[mediatorType];
		}
	}
}
