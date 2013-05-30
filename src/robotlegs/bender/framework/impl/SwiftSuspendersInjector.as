//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{
	import flash.events.Event;
	import flash.system.ApplicationDomain;

	import org.swiftsuspenders.Injector;
	import org.swiftsuspenders.dependencyproviders.FallbackDependencyProvider;
	import org.swiftsuspenders.mapping.InjectionMapping;
	import org.swiftsuspenders.typedescriptions.TypeDescription;

	import robotlegs.bender.framework.api.IInjector;

	public class SwiftSuspendersInjector extends Injector implements IInjector
	{


		public function createChild(applicationDomain:ApplicationDomain=null):IInjector
		{
			const childInjector : IInjector = new SwiftSuspendersInjector();
			childInjector.applicationDomain = applicationDomain;
			childInjector.parent = this;
			return childInjector;
		}

		public function set parent(parentInjector:IInjector):void
		{
			this.parentInjector = parentInjector as SwiftSuspendersInjector;
		}

		public function get parent():IInjector
		{
			return this.parentInjector as SwiftSuspendersInjector;
		}

	}
}
