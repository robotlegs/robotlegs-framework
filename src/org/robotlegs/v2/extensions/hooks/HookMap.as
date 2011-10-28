//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.hooks
{
	import flash.utils.Dictionary;
	import org.robotlegs.v2.core.api.ITypeMatcher;
	import org.robotlegs.v2.core.api.ITypeFilter;
	import org.robotlegs.v2.core.impl.tddasifyoumeanit.itemPassesFilter;
	import org.swiftsuspenders.Injector;
	import org.swiftsuspenders.DescribeTypeJSONReflector;
	import org.swiftsuspenders.Reflector;
	import org.robotlegs.v2.extensions.guards.GuardsProcessor;
	import flash.utils.getQualifiedClassName;

	public class HookMap
	{
		/*============================================================================*/
		/* Public Properties         	                                              */
		/*============================================================================*/
		
		[Inject]
		public var injector:Injector;
		
		[Inject]
		public var hooksProcessor:HooksProcessor;
		
		[Inject]
		public var guardsProcessor:GuardsProcessor;
		
		[Inject]
		public var reflector:Reflector;
		
		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/

		private var _mappingsByFCQN:Dictionary;
		private var _mappingsByMatcher:Dictionary;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function HookMap()
		{
			_mappingsByMatcher = new Dictionary();
			_mappingsByFCQN = new Dictionary();
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function map(clazz:Class):GuardsAndHooksMapBinding
		{
			// TODO - overwrite? warnings? allow extension? handle duplicates? hrm.
			
			const fcqn:String = reflector.getFQCN(clazz);
			
			_mappingsByFCQN[fcqn] = new GuardsAndHooksMapBinding();
			
			return _mappingsByFCQN[fcqn];
		}
				
		public function mapMatcher(matcher:ITypeMatcher):GuardsAndHooksMapBinding
		{
			const filter:ITypeFilter = matcher.createTypeFilter();
			_mappingsByMatcher[filter] = new GuardsAndHooksMapBinding();
			
			return _mappingsByMatcher[filter];
		}
		
		public function process(item:*):Boolean
		{			
			const fcqn:String = getQualifiedClassName(item);
			
			var interested:Boolean = false;
			
			if(_mappingsByFCQN[fcqn])
			{
				interested = true;
				if(!blockedByGuards(_mappingsByFCQN[fcqn].guards) )
					hooksProcessor.runHooks(injector, _mappingsByFCQN[fcqn].hooks);
			}
			
			for (var filter:* in _mappingsByMatcher)
			{
				if(itemPassesFilter(item, filter as ITypeFilter))
				{
					interested = true;
					if(!blockedByGuards(_mappingsByMatcher[filter].guards) )
						hooksProcessor.runHooks(injector, _mappingsByMatcher[filter].hooks);
				}
			}
			
			return interested;
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/
		
		protected function blockedByGuards(guards:Vector.<Class>):Boolean
		{
			return ((guards.length > 0) 
					&& !( guardsProcessor.processGuards(injector , guards) ) )
		}
	}
}