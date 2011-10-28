//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap.impl
{
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import org.robotlegs.v2.core.api.ITypeFilter;
	import org.robotlegs.v2.core.impl.itemPassesFilter;
	import org.robotlegs.v2.extensions.guards.GuardsProcessor;
	import org.robotlegs.v2.extensions.hooks.HooksProcessor;
	import org.robotlegs.v2.view.api.IViewClassInfo;
	import org.robotlegs.v2.view.api.IViewHandler;
	import org.robotlegs.v2.view.api.IViewWatcher;
	import org.robotlegs.v2.view.api.ViewHandlerEvent;
	import org.swiftsuspenders.Injector;
	import org.swiftsuspenders.Reflector;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediatorMap;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediatorMapping;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediatorConfig;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediatorTrigger;

	[Event(name="configurationChange", type="org.robotlegs.v2.view.api.ViewHandlerEvent")]
	public class MediatorMap extends EventDispatcher implements IViewHandler, IMediatorMap
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

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

		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/

		protected var _configsByTypeFilter:Dictionary;

		protected var _filtersByDescription:Dictionary;

		// vars not consts as some sort of shudown would likely dump the lot

		protected var _mappingsByMediatorType:Dictionary;
		
		protected var _trigger:IMediatorTrigger;
		
		protected var _liveMediatorsByView:Dictionary;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function MediatorMap()
		{
			_mappingsByMediatorType = new Dictionary();
			_filtersByDescription = new Dictionary();
			_configsByTypeFilter = new Dictionary();
			_liveMediatorsByView = new Dictionary();
		}


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function getMapping(mediatorType:Class):IMediatorMapping
		{
			return _mappingsByMediatorType[mediatorType];
		}

		public function handleViewAdded(view:DisplayObject, info:IViewClassInfo):uint
		{
			var interest:uint = 0;

			for (var filter:* in _configsByTypeFilter)
			{
				if (itemPassesFilter(view, filter as ITypeFilter))
				{
					interest = 1;
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
			if(_liveMediatorsByView[view])
			{
				for each (var mediator:* in _liveMediatorsByView[view])
				{
					_trigger.shutdown(mediator, view, cleanUpMediator);
				}
			}
		}

		public function hasMapping(mediatorType:Class):Boolean
		{
			return (_mappingsByMediatorType[mediatorType] != null);
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

		public function unmap(mediatorType:Class):void
		{
			if (_mappingsByMediatorType[mediatorType])
				_mappingsByMediatorType[mediatorType].unmapAll();

			delete _mappingsByMediatorType[mediatorType];
		}
		
		public function loadTrigger(trigger:IMediatorTrigger):void
		{
			_trigger = trigger;
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/

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
				mediatorType);
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
				
				if(!_liveMediatorsByView[view])
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
			const index:int = _liveMediatorsByView[view].indexOf(mediator);
			if(index > -1)
			{
				_liveMediatorsByView[view].splice(index, 1);
			}
		}
	}
}