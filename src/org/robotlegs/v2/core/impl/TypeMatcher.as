//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.core.impl
{
	import flash.errors.IllegalOperationError;
	import org.robotlegs.v2.core.api.ITypeFilter;
	import org.robotlegs.v2.core.api.ITypeMatcher;

	public class TypeMatcher implements ITypeMatcher
	{

		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/

		protected const _allOfTypes:Vector.<Class> = new Vector.<Class>;

		protected const _anyOfTypes:Vector.<Class> = new Vector.<Class>;

		protected const _noneOfTypes:Vector.<Class> = new Vector.<Class>;

		protected var _typeFilter:ITypeFilter;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function TypeMatcher()
		{
		}


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function allOf(... types):ITypeMatcher
		{
			if(types.length == 1)
			{
				if(types[0] is Array)
				{
					types = types[0]
				}
				else if(types[0] is Vector.<Class>)
				{
					types = createArrayFromVector(types[0]);
				}
			}
			
			_typeFilter && throwSealedMatcherError();
			for each (var type:Class in types)
			{
				_allOfTypes.push(type);
			}
			return this;
		}

		public function anyOf(... types):ITypeMatcher
		{
			if(types.length == 1)
			{
				if(types[0] is Array)
				{
					types = types[0]
				}
				else if(types[0] is Vector.<Class>)
				{
					types = createArrayFromVector(types[0]);
				}
			}
			
			_typeFilter && throwSealedMatcherError();
			for each (var type:Class in types)
			{
				_anyOfTypes.push(type);
			}
			return this;
		}

		public function createTypeFilter():ITypeFilter
		{
			// calling this seals the matcher
			return _typeFilter ||= buildTypeFilter();
		}

		public function lock():void
		{
			createTypeFilter();
		}

		public function noneOf(... types):ITypeMatcher
		{
			if(types.length == 1)
			{
				if(types[0] is Array)
				{
					types = types[0]
				}
				else if(types[0] is Vector.<Class>)
				{
					types = createArrayFromVector(types[0]);
				}
			}
			
			_typeFilter && throwSealedMatcherError();
			for each (var type:Class in types)
			{
				_noneOfTypes.push(type);
			}
			return this;
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/

		protected function buildTypeFilter():ITypeFilter
		{
			if ((_allOfTypes.length == 0) &&
				(_anyOfTypes.length == 0) &&
				(_noneOfTypes.length == 0))
			{
				throw new TypeMatcherError(TypeMatcherError.EMPTY_MATCHER);
			}
			return new TypeFilter(_allOfTypes, _anyOfTypes, _noneOfTypes);
		}

		protected function throwSealedMatcherError():void
		{
			throw new IllegalOperationError('This TypeMatcher has been sealed and can no longer be configured');
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
}
