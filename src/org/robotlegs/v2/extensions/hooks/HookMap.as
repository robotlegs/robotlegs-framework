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

		public function map(clazz:Class):GuardsAndHooksMapBinding
		{
			_hooksByClazz[clazz] = new GuardsAndHooksMapBinding();
			
			return _hooksByClazz[clazz];
		}
		
		public function mapMatcher(matcher:ITypeMatcher):GuardsAndHooksMapBinding
		{
			const filter:ITypeFilter = matcher.createTypeFilter();
			_hooksByMatcher[filter] = new GuardsAndHooksMapBinding();
			
			return _hooksByMatcher[filter];
		}
		
		public function process(item:*):Boolean
		{			
			// TODO - dammit, this is way too permissive, we don't want
			// our subclasses getting this special treatment!
			
			var interested:Boolean = false;
			
			for (var clazz:* in _hooksByClazz)
			{
				if(item is (clazz as Class))
				{
					interested = true;
					if(!blockedByGuards(_hooksByClazz[clazz].guards) )
						hooksProcessor.runHooks(injector, _hooksByClazz[clazz].hooks);
				}
			}
			
			for (var filter:* in _hooksByMatcher)
			{
				if(itemPassesFilter(item, filter as ITypeFilter))
				{
					interested = true;
					if(!blockedByGuards(_hooksByMatcher[filter].guards) )
						hooksProcessor.runHooks(injector, _hooksByMatcher[filter].hooks);
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