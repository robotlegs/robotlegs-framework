//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap
{
	import flash.utils.Dictionary;
	import org.robotlegs.v2.core.api.ITypeFilter;
	import org.robotlegs.v2.core.api.ITypeMatcher;
	import org.swiftsuspenders.Reflector;

	public class MediatorUnmapping implements IMediatorUnmapping
	{

		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/

		protected var _mediatorClazz:Class;

		protected var _mediatorMappings:Dictionary;

		protected var _reflector:Reflector;

		protected var _typeFilter:ITypeFilter;

		protected var _typeFilterMap:Dictionary;

		protected var _viewFCQNMap:Dictionary;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function MediatorUnmapping(mediatorMappings:Dictionary, viewFCQNMap:Dictionary, typeFilterMap:Dictionary, mediatorClazz:Class, reflector:Reflector)
		{
			_viewFCQNMap = viewFCQNMap;
			_typeFilterMap = typeFilterMap;
			_mediatorClazz = mediatorClazz;
			_reflector = reflector;
			_mediatorMappings = mediatorMappings;
		}


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function fromMatcher(typeMatcher:ITypeMatcher):void
		{
			_typeFilter = typeMatcher.createTypeFilter();
			delete _typeFilterMap[_typeFilter];

			delete _mediatorMappings[_typeFilter.descriptor];
		}

		public function fromView(viewClazz:Class):void
		{
			const fqcn:String = _reflector.getFQCN(viewClazz);
			delete _viewFCQNMap[fqcn];

			delete _mediatorMappings[fqcn];
		}
	}
}
