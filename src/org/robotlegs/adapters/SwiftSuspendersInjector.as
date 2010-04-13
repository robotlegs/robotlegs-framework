/*
 * Copyright (c) 2009 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package org.robotlegs.adapters
{
	import org.robotlegs.core.IInjector;
	import org.swiftsuspenders.Injector;
	
	/**
	 * SwiftSuspender <code>IInjector</code> adpater - See: <a href="http://github.com/tschneidereit/SwiftSuspenders">SwiftSuspenders</a>
	 *
	 * @author tschneidereit
	 */
	public class SwiftSuspendersInjector implements IInjector
	{
		protected var injector:Injector;
		
		protected static const XML_CONFIG:XML =
			<types>
				<type name='org.robotlegs.mvcs::Actor'>
					<field name='eventDispatcher'/>
				</type>
				<type name='org.robotlegs.mvcs::Command'>
					<field name='contextView'/>
					<field name='mediatorMap'/>
					<field name='eventDispatcher'/>
					<field name='injector'/>
					<field name='commandMap'/>
				</type>
				<type name='org.robotlegs.mvcs::Mediator'>
					<field name='contextView'/>
					<field name='mediatorMap'/>
					<field name='eventDispatcher'/>
				</type>
			</types>;
		
		public function SwiftSuspendersInjector(xmlConfig:XML = null, injector:Injector = null)
		{
			if (xmlConfig)
			{
				for each (var typeNode:XML in XML_CONFIG.children())
				{
					xmlConfig.appendChild(typeNode);
				}
			}
			this.injector = injector || new Injector(xmlConfig);
		}
		
		/**
		 * @inheritDoc
		 */
		public function mapValue(whenAskedFor:Class, useValue:Object, named:String = ""):*
		{
			return injector.mapValue(whenAskedFor, useValue, named);
		}
		
		/**
		 * @inheritDoc
		 */
		public function mapClass(whenAskedFor:Class, instantiateClass:Class, named:String = ""):*
		{
			return injector.mapClass(whenAskedFor, instantiateClass, named);
		}
		
		/**
		 * @inheritDoc
		 */
		public function mapSingleton(whenAskedFor:Class, named:String = ""):*
		{
			return injector.mapSingleton(whenAskedFor, named);
		}
		
		/**
		 * @inheritDoc
		 */
		public function mapSingletonOf(whenAskedFor:Class, useSingletonOf:Class, named:String = ""):*
		{
			return injector.mapSingletonOf(whenAskedFor, useSingletonOf, named);
		}
		
		/**
		 * @inheritDoc
		 */
		public function mapRule(whenAskedFor:Class, useRule:*, named:String = ""):*
		{
			return injector.mapRule(whenAskedFor, useRule, named);
		}
		
		/**
		 * @inheritDoc
		 */
		public function injectInto(target:Object):void
		{
			injector.injectInto(target);
		}
		
		/**
		 * @inheritDoc
		 */
		public function instantiate(clazz:Class):*
		{
			return injector.instantiate(clazz);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getInstance(clazz:Class, named:String = ""):*
		{
			return injector.getInstance(clazz, named);
		}
		
		/**
		 * @inheritDoc
		 */
		public function createChildInjector():IInjector
		{
			return new SwiftSuspendersInjector(null, injector.createChildInjector());
		}
		
		/**
		 * @inheritDoc
		 */
		public function unmap(clazz:Class, named:String = ""):void
		{
			injector.unmap(clazz, named);
		}
	
	}
}