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

	public class HookMap
	{
		/*============================================================================*/
		/* Public Properties         	                                              */
		/*============================================================================*/
		
		[Inject]
		public var injector:Injector;
		
		[Inject]
		public var hooksProcessor:HooksProcessor;
		
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
					hooksProcessor.runHooks(injector, _hooksByClazz[clazz].hooks);
				}
			}
			for (var filter:* in _hooksByMatcher)
			{
				if(itemPassesFilter(item, filter as ITypeFilter))
				{
					hooksProcessor.runHooks(injector, _hooksByMatcher[filter].hooks);
				}
			}
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/
		
	}
}

class MapBinding
{
	protected var _hooks:Vector.<Class> = new Vector.<Class>();
	
	public function get hooks():Vector.<Class>
	{
		return _hooks;
	}
	
	public function toHook(hookClass:Class):void
	{
		hooks.push(hookClass);
	}
	
	public function toHooks(...hookClasses):void
	{
		if(hookClasses.length==1)
		{
			if(hookClasses[0] is Array)
			{
				hookClasses = hookClasses[0]
			}
			else if(hookClasses[0] is Vector.<Class>)
			{
				hookClasses = createArrayFromVector(hookClasses[0]);
			}
		}
		
		for each (var clazz:Class in hookClasses)
		{
			hooks.push(clazz);
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