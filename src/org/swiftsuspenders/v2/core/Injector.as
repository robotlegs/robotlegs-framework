//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.swiftsuspenders.v2.core
{
	import org.robotlegs.adapters.SwiftSuspendersInjector;
	import org.robotlegs.core.IInjector;
	import org.swiftsuspenders.v2.dsl.IFactoryMap;
	import org.swiftsuspenders.v2.dsl.IFactoryMapper;
	import org.swiftsuspenders.v2.dsl.IInjector;

	public class Injector implements org.swiftsuspenders.v2.dsl.IInjector
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var factoryMap:IFactoryMap = new FactoryMap();

		public var hack_inj:org.robotlegs.core.IInjector

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function Injector()
		{
			hack_inj = new SwiftSuspendersInjector();
		}


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function getInstance(type:Class, named:String = ''):*
		{
			return hack_inj.getInstance(type, named);
		}

		public function map(type:Class, named:String = ''):IFactoryMapper
		{
			const request:FactoryRequest = new FactoryRequest(type, named);
			const mapper:FactoryMapper = new FactoryMapper(factoryMap, request, hack_inj);
			return mapper;
		}
	}
}
