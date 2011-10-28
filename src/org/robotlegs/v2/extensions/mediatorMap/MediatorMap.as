//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	import org.robotlegs.v2.core.api.ITypeFilter;
	import org.robotlegs.v2.extensions.guards.GuardsProcessor;
	import org.robotlegs.v2.extensions.hooks.HooksProcessor;
	import org.robotlegs.v2.view.api.IViewClassInfo;
	import org.robotlegs.v2.view.api.IViewHandler;
	import org.robotlegs.v2.view.api.IViewWatcher;
	import org.swiftsuspenders.Injector;
	import org.swiftsuspenders.Reflector;
	import flash.utils.getQualifiedClassName;
	import org.robotlegs.v2.core.impl.itemPassesFilter;
	import org.robotlegs.v2.extensions.mediatorMap.IMediatorMapping;
	
	
	public class  MediatorMap implements IViewHandler
	{
		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		[Inject]
		public var injector:Injector;
		
		[Inject]
		public var reflector:Reflector;
				
		[Inject]
		public var hooksProcessor:HooksProcessor;
		
		[Inject]
		public var guardsProcessor:GuardsProcessor;
		
		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/

		// vars not consts as some sort of shudown would likely dump the lot
		
		protected var _mappingsByMediatorClazz:Dictionary;
				
		protected var _configsByTypeFilter:Dictionary;
		
		protected var _filtersByDescription:Dictionary;
		
		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function MediatorMap()
		{
			_mappingsByMediatorClazz = new Dictionary();
			_filtersByDescription = new Dictionary();
			_configsByTypeFilter = new Dictionary();
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function get interests():uint
		{
			return 0;
		}

		public function handleViewAdded(view:DisplayObject, info:IViewClassInfo):uint
		{
			var interest:uint = 0;
			
			for (var filter:* in _configsByTypeFilter)
			{
				if(itemPassesFilter(view, filter as ITypeFilter))
				{
					interest = 1;
					mapViewForFilterBinding(filter, view);
					
					for each (var config:IMediatorConfig in _configsByTypeFilter[filter])
					{
						processMapping (config);
					}
					
				}
			}
			
			return interest;
		}

		public function handleViewRemoved(view:DisplayObject):void
		{
	
		}

		public function register(watcher:IViewWatcher):void
		{
	
		}
		
		public function map(mediatorClazz:Class):IMediatorMapping
		{						
			if(!_mappingsByMediatorClazz[mediatorClazz])
				_mappingsByMediatorClazz[mediatorClazz] = createMediatorMapping(mediatorClazz);
						
			return _mappingsByMediatorClazz[mediatorClazz];
		}
		
		public function getMapping(mediatorClazz:Class):IMediatorMapping
		{
			return _mappingsByMediatorClazz[mediatorClazz];
		}
		
		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/
				
		protected function createMediatorMapping(mediatorClazz:Class):IMediatorMapping
		{
			return new MediatorMapping(_configsByTypeFilter, 
								_filtersByDescription, 
								mediatorClazz);
		}	
				
		protected function processMapping(config:IMediatorConfig):void
		{
			if(!blockedByGuards(config.guards))
			{
				createMediatorForBinding(config);
				hooksProcessor.runHooks(injector, config.hooks);
			}
		}

	
		protected function mapViewForFilterBinding(filter:ITypeFilter, view:DisplayObject):void
		{
			var requiredClazz:Class;
			
			for each (requiredClazz in filter.allOfTypes)
			{
				injector.map(requiredClazz).toValue(view);
			}
			
			for each (requiredClazz in filter.anyOfTypes)
			{
				injector.map(requiredClazz).toValue(view);
			}
		}
		
		protected function createMediatorForBinding(config:IMediatorConfig):void
		{
			const mediator:* = injector.getInstance(config.mapping.mediator);
			injector.map(config.mapping.mediator).toValue(mediator);
		}
		
		protected function blockedByGuards(guards:Vector.<Class>):Boolean
		{
			return ((guards.length > 0) 
					&& !( guardsProcessor.processGuards(injector , guards) ) )
		}
	}
}