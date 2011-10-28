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
		
		protected var _mappingsByViewFCQN:Dictionary;
		
		protected var _mappingsByTypeFilter:Dictionary;
		
		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function MediatorMap()
		{
			_mappingsByMediatorClazz = new Dictionary();
			_mappingsByViewFCQN = new Dictionary();
			_mappingsByTypeFilter = new Dictionary();
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
			const fqcn:String = getQualifiedClassName(view);
			var interest:uint = 0;
			
			if(_mappingsByViewFCQN[fqcn])
			{
				interest = 1;
				mapViewForTypeBinding(_mappingsByViewFCQN[fqcn], view);
				processMapping( _mappingsByViewFCQN[fqcn]);
			}	
			
			for (var filter:* in _mappingsByTypeFilter)
			{
				if(itemPassesFilter(view, filter as ITypeFilter))
				{
					interest = 1;
					mapViewForFilterBinding(filter, view);
					processMapping (_mappingsByTypeFilter[filter]);
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
			// TODO = fix the fatal flaw with this plan - we can only have one mapping per mediator...
			
			_mappingsByMediatorClazz[mediatorClazz] = new MediatorMapping(_mappingsByViewFCQN, _mappingsByTypeFilter, mediatorClazz, reflector);
			
			return _mappingsByMediatorClazz[mediatorClazz];
		}
		

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/
		
		protected function processMapping(binding:IMediatorMapping):void
		{
			if(!blockedByGuards(binding.guards))
			{
				createMediatorForBinding(binding);
				hooksProcessor.runHooks(injector, binding.hooks);
			}
		}

		protected function mapViewForTypeBinding(binding:IMediatorMapping, view:DisplayObject):void
		{
			injector.map(binding.viewClass).toValue(view);
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
		
		protected function createMediatorForBinding(binding:IMediatorMapping):void
		{
			const mediator:* = injector.getInstance(binding.mediatorClass);
			injector.map(binding.mediatorClass).toValue(mediator);
		}
		
		protected function blockedByGuards(guards:Vector.<Class>):Boolean
		{
			return ((guards.length > 0) 
					&& !( guardsProcessor.processGuards(injector , guards) ) )
		}
	}
}