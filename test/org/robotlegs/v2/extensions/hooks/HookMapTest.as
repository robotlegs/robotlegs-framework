//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.hooks 
{
	import org.flexunit.asserts.*;
	import org.flexunit.asserts.assertEqualsVectorsIgnoringOrder;
	import org.swiftsuspenders.Injector;
	import flash.utils.Dictionary;
	import org.robotlegs.v2.extensions.hooks.HooksProcessor;
	import flash.display.DisplayObject;
	import org.robotlegs.v2.core.impl.TypeMatcher;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import org.robotlegs.v2.core.api.ITypeMatcher;
	import org.robotlegs.v2.core.api.ITypeFilter;
	import org.robotlegs.v2.core.impl.tddasifyoumeanit.itemPassesFilter;

	public class HookMapTest 
	{
		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var instance:HookMap;
		private var injector:Injector;
		private const hookTracker:HookTracker = new HookTracker();
		private var _hooksByClazz:Dictionary;
		private var _hooksByMatcher:Dictionary;
		private var hooksProcessor:HooksProcessor;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function setUp():void
		{
			instance = new HookMap();
			injector = new Injector();
			injector.map(HookTracker).toValue(hookTracker);
			hooksProcessor = new HooksProcessor();
			_hooksByClazz = new Dictionary();
			_hooksByMatcher = new Dictionary();
		}

		[After]
		public function tearDown():void
		{
			instance = null;
			injector = null;
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function can_be_instantiated():void
		{
			assertTrue("instance is HookMap", instance is HookMap);
		}
		
		[Test]
		public function test_failure_seen():void
		{
			assertTrue("Failing test", true);
		}
		
		[Test]
		public function a_hook_is_instantiated_and_run():void
		{
			var exampleHook:ExampleHook = new ExampleHook();
			exampleHook.hook();
			assertEquals("the example hook has been run", 1, exampleHook.runCount);
		}
		
		[Test]
		public function a_hook_is_run_after_mapping_with_injections():void
		{
			map(ExampleTarget).toHook(TrackableHook1);
			process(new ExampleTarget());
			var expectedHooksConfirmed:Vector.<String> = new <String>['TrackableHook1'];
			assertEqualsVectorsIgnoringOrder('hook ran in response to trigger class', expectedHooksConfirmed, hookTracker.hooksConfirmed);
		}
		
		[Test]
		public function multiple_hooks_run_after_mapping():void
		{
			map(ExampleTarget).toHooks(TrackableHook1, TrackableHook2);
			process(new ExampleTarget());
			var expectedHooksConfirmed:Vector.<String> = new <String>['TrackableHook1', 'TrackableHook2'];
			assertEqualsVectorsIgnoringOrder('both hooks have run in response to trigger class', expectedHooksConfirmed, hookTracker.hooksConfirmed);
		}
		
		[Test]
		public function runs_hooks_against_matched_matcher():void
		{
			mapMatcher(new TypeMatcher().allOf(DisplayObject)).toHooks(TrackableHook1, TrackableHook2);
			process(new Sprite());
			var expectedHooksConfirmed:Vector.<String> = new <String>['TrackableHook1', 'TrackableHook2'];
			assertEqualsVectorsIgnoringOrder('both hooks have run in response to class matching the matcher', expectedHooksConfirmed, hookTracker.hooksConfirmed);
		}
		
		[Test]
		public function no_hooks_run_for_unmatched_object():void
		{
			mapMatcher(new TypeMatcher().allOf(MovieClip)).toHooks(TrackableHook1, TrackableHook2);
			process(new Sprite());
			var expectedHooksConfirmed:Vector.<String> = new <String>[];
			assertEqualsVectorsIgnoringOrder('no hooks run for unmatched object', expectedHooksConfirmed, hookTracker.hooksConfirmed);
			
		}
		
		// always_returns_non_blocking_bitmask
		
		// returns_true_if_interested
		
		// returns_false_if_not_interested
		
		// unmapping_the_hook_prevents_it_from_running
		
		// a_grumpy_guard_prevents_the_hook_from_running
		
		// all_happy_guards_allow_the_hook_to_run

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/
		
		protected function map(clazz:Class):MapBinding
		{
			_hooksByClazz[clazz] = new MapBinding();
			
			return _hooksByClazz[clazz];
		}
		
		protected function mapMatcher(matcher:ITypeMatcher):MapBinding
		{
			const filter:ITypeFilter = matcher.createTypeFilter();
			_hooksByMatcher[filter] = new MapBinding();
			
			return _hooksByMatcher[filter];
		}
		
		protected function process(item:*):void
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

class ExampleHook 
{
	[Inject]
	
	public var runCount:uint = 0;
	
	public function hook():void
	{
		runCount++;
	}
}

class TrackableHook1
{
	[Inject]
	public var hookTracker:HookTracker;
	
	public function hook():void
	{
		hookTracker.confirm("TrackableHook1");
	}
}

class TrackableHook2
{
	[Inject]
	public var hookTracker:HookTracker;
	
	public function hook():void
	{
		hookTracker.confirm("TrackableHook2");
	}
}

class HookTracker
{
	public var hooksConfirmed:Vector.<String> = new Vector.<String>();
	
	public function confirm(hookName:String):void
	{
		hooksConfirmed.push(hookName);
	}
}

class ExampleTarget
{
	public function ExampleTarget()
	{
	}
}