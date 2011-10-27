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
	import org.robotlegs.v2.extensions.guards.GuardsProcessor;

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
		
		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/

		private var _hooksByClazz:Dictionary;
		private var _hooksByMatcher:Dictionary;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function HookMap()
		{
			_hooksByMatcher = new Dictionary();
			_hooksByClazz = new Dictionary();
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function map(clazz:Class):MapBinding
		{
			_hooksByClazz[clazz] = new MapBinding();
			
			return _hooksByClazz[clazz];
		}
		
		public function mapMatcher(matcher:ITypeMatcher):MapBinding
		{
			const filter:ITypeFilter = matcher.createTypeFilter();
			_hooksByMatcher[filter] = new MapBinding();
			
			return _hooksByMatcher[filter];
		}
		
		public function process(item:*):void
		{			
			for (var clazz:* in _hooksByClazz)
			{
				if(item is (clazz as Class))
				{
					if(!blockedByGuards(_hooksByClazz[clazz].guards) )
						hooksProcessor.runHooks(injector, _hooksByClazz[clazz].hooks);
				}
			}
			for (var filter:* in _hooksByMatcher)
			{
				if(itemPassesFilter(item, filter as ITypeFilter))
				{
					if(!blockedByGuards(_hooksByMatcher[filter].guards) )
						hooksProcessor.runHooks(injector, _hooksByMatcher[filter].hooks);
				}
			}
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

class MapBinding
{
	protected var _hooks:Vector.<Class> = new Vector.<Class>();
	protected var _guards:Vector.<Class> = new Vector.<Class>();
	
	public function get hooks():Vector.<Class>
	{
		return _hooks;
	}
	
	public function get guards():Vector.<Class>
	{
		return _guards;
	}
	
	public function toHook(hookClass:Class):MapBinding
	{
		hooks.push(hookClass);
		return this;
	}
	
	public function toHooks(...hookClasses):MapBinding
	{
		pushValuesToVector(hookClasses, _hooks);
		
		return this;
	}
	
	public function withGuards(...guardClasses):MapBinding
	{
		pushValuesToVector(guardClasses, _guards);
		
		return this;
	}
	
	protected function pushValuesToVector(values:Array, vector:Vector.<Class>):void
	{
		if(values.length==1)
		{
			if(values[0] is Array)
			{
				values = values[0]
			}
			else if(values[0] is Vector.<Class>)
			{
				values = createArrayFromVector(values[0]);
			}
		}
		
		for each (var clazz:Class in values)
		{
			vector.push(clazz);
		}
	}
	
	protected function createArrayFromVector(typesVector:Vector.<Class>):Array
	{
		const returnArray:Array = [];

		for each (var type:Class in typesVector)
		{
			returnArray.push(type);
		}

		return returnArray;
	}
}