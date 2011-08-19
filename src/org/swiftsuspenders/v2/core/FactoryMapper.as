//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.swiftsuspenders.v2.core
{
	import org.swiftsuspenders.v2.dsl.IFactory;
	import org.swiftsuspenders.v2.dsl.IFactoryMap;
	import org.swiftsuspenders.v2.dsl.IFactoryMapper;
	import org.swiftsuspenders.v2.dsl.IFactoryMapping;
	import org.swiftsuspenders.v2.dsl.IFactoryRequest;
	import org.swiftsuspenders.v2.factories.Hack;
	import org.swiftsuspenders.v2.factories.SingletonFactory;

	public class FactoryMapper implements IFactoryMapper
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var factoryMap:IFactoryMap;

		private var request:IFactoryRequest;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function FactoryMapper(factoryMap:IFactoryMap, request:IFactoryRequest)
		{
			this.factoryMap = factoryMap;
			this.request = request;
		}


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function asPrototype(implementation:Class = null):IFactory
		{
			Hack.inj.mapClass(request.type, implementation || request.type, request.name);
			return null;
		}

		public function asSingleton(implementation:Class = null):IFactory
		{
			Hack.inj.mapSingletonOf(request.type, implementation || request.type, request.name);
			return toFactory(new SingletonFactory(implementation));
		}

		public function toFactory(factory:IFactory):IFactory
		{
			const mapping:IFactoryMapping = new FactoryMapping(request, factory);
			factoryMap.addMapping(mapping);
			return factory;
		}

		public function toFactoryClass(factoryClass:Class):IFactory
		{
			return null;
		}

		public function toInstance(instance:*):IFactory
		{
			Hack.inj.mapValue(request.type, instance, request.name);
			return null;
		}
	}
}
