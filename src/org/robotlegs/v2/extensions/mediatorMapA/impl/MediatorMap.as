//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMapA.impl
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import org.robotlegs.v2.core.api.ITypeFilter;
	import org.robotlegs.v2.extensions.viewManager.api.IViewClassInfo;
	import org.robotlegs.v2.extensions.viewManager.api.IViewHandler;
	import org.robotlegs.v2.extensions.viewManager.api.ViewHandlerEvent;
	import org.robotlegs.v2.extensions.mediatorMapA.api.IMediatorConfig;
	import org.robotlegs.v2.extensions.mediatorMapA.api.IMediatorMap;
	import org.robotlegs.v2.extensions.mediatorMapA.api.IMediatorMapping;
	import org.robotlegs.v2.extensions.mediatorMapA.api.IMediatorTrigger;
	import org.robotlegs.v2.extensions.mediatorMapA.api.IMediatorUnmapping;
	import org.swiftsuspenders.Injector;
	import flash.errors.IllegalOperationError;
	import org.robotlegs.v2.extensions.viewManager.api.ViewInterests;

	[Event(name="configurationChange", type="org.robotlegs.v2.extensions.viewManager.api.ViewHandlerEvent")]
	public class MediatorMap extends EventDispatcher implements IViewHandler, IMediatorMap
	{
		[Inject]
		public var injector:Injector;

		public function get interests():uint
		{
			return ViewInterests.MEDIATION;
		}

		private const _configsByTypeFilter:Dictionary = new Dictionary();

		private const _filtersByDescription:Dictionary = new Dictionary();

		private const _liveMediatorsByView:Dictionary = new Dictionary();

		private const _mappingsByMediatorType:Dictionary = new Dictionary();

		private var _trigger:IMediatorTrigger;

		private const _viewsInRemovalPhase:Dictionary = new Dictionary();


		public function getMapping(mediatorType:Class):IMediatorMapping
		{
			return _mappingsByMediatorType[mediatorType];
		}

		public function processView(view:DisplayObject, info:IViewClassInfo):uint
		{
			// TODO = check _liveMediatorsByView for this view, exit / error if it would overwrite
			// TODO - probably refactor to a linked list for iteration
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

					for each (var config:MediatorConfig in _configsByTypeFilter[filter])
					{
						processMapping(config, view);
					}

					unmapViewForFilterBinding(filter, view);
				}
			}

			return interest;
		}

		public function releaseView(view:DisplayObject):void
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
			dispatchEvent(new ViewHandlerEvent(ViewHandlerEvent.HANDLER_CONFIGURATION_CHANGE));
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

		private function createMediatorForBinding(config:MediatorConfig):*
		{
			const mediator:* = injector.getInstance(config.mapping.mediator);
			injector.map(config.mapping.mediator).toValue(mediator);
			return mediator;
		}

		private function createMediatorMapping(mediatorType:Class):IMediatorMapping
		{
			return new MediatorMapping(_configsByTypeFilter,
				_filtersByDescription,
				mediatorType,
				cleanUpMapping,
				injector);
		}

		private function mapViewForFilterBinding(filter:ITypeFilter, view:DisplayObject):void
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

		private function processMapping(config:MediatorConfig, view:DisplayObject):void
		{
			if(config.guards.approve())
			{
				const mediator:* = createMediatorForBinding(config);
				config.hooks.hook();
				injector.unmap(config.mapping.mediator);

				if (!_liveMediatorsByView[view])
					_liveMediatorsByView[view] = [];

				_liveMediatorsByView[view].push(mediator);

				_trigger.startup(mediator, view);
			}
		}

		private function unmapViewForFilterBinding(filter:ITypeFilter, view:DisplayObject):void
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

		private function cleanUpMediator(mediator:*, view:DisplayObject):void
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

		private function cleanUpMapping(mediatorType:Class):void
		{
			delete _mappingsByMediatorType[mediatorType];
		}
	}
}