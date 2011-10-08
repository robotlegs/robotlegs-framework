/*
 * Copyright (c) 2009 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package org.robotlegs.adapters
{
	import flash.system.ApplicationDomain;
	
	import org.robotlegs.core.IInjector;
	import org.swiftsuspenders.Injector;
	import org.swiftsuspenders.dependencyproviders.ForwardingProvider;

	/**
	 * SwiftSuspender <code>IInjector</code> adpater - See: <a href="http://github.com/tschneidereit/SwiftSuspenders">SwiftSuspenders</a>
	 *
	 * @author tschneidereit
	 */
	public class SwiftSuspendersInjector extends Injector implements IInjector
	{
		/**
		 * @inheritDoc
		 */
		public function createChild(applicationDomain:ApplicationDomain = null):IInjector
		{
			var injector:SwiftSuspendersInjector = new SwiftSuspendersInjector();
			injector.applicationDomain = applicationDomain;
			injector.parentInjector = this;
			return injector;
		}

		public function mapValue(whenAskedFor : Class, useValue : Object, named : String = "") : *
		{
			return map(whenAskedFor, named).toValue(useValue);
		}

		public function mapClass(
				whenAskedFor : Class, instantiateClass : Class, named : String = "") : *
		{
			return map(whenAskedFor, named).toType(instantiateClass);
		}

		public function mapSingleton(whenAskedFor : Class, named : String = "") : *
		{
			return map(whenAskedFor, named).asSingleton();
		}

		public function mapSingletonOf(
				whenAskedFor : Class, useSingletonOf : Class, named : String = "") : *
		{
			return map(whenAskedFor, named).toSingleton(useSingletonOf);
		}

		public function mapRule(whenAskedFor : Class, useRule : *, named : String = "") : *
		{
			return map(whenAskedFor, named).toProvider(new ForwardingProvider(useRule));
		}

		public function instantiate(clazz : Class) : *
		{
			return getInstance(clazz);
		}

		public function hasMapping(clazz : Class, named : String = "") : Boolean
		{
			return satisfies(clazz, named);
		}
	}
}