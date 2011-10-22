//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
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

		protected var _allOfTypes:Vector.<Class> = new Vector.<Class>;

		protected var _anyOfTypes:Vector.<Class> = new Vector.<Class>;

		protected var _noneOfTypes:Vector.<Class> = new Vector.<Class>;

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

		public function allOf(types:Vector.<Class>):ITypeMatcher
		{
			_typeFilter && throwSealedMatcherError();
			_allOfTypes = _allOfTypes.concat(types);
			return this;
		}

		public function anyOf(types:Vector.<Class>):ITypeMatcher
		{
			_typeFilter && throwSealedMatcherError();
			_anyOfTypes = _anyOfTypes.concat(types);
			return this;
		}

		public function noneOf(types:Vector.<Class>):ITypeMatcher
		{
			_typeFilter && throwSealedMatcherError();
			_noneOfTypes = _noneOfTypes.concat(types);
			return this;
		}
		
		public function lock():void
		{
			createTypeFilter();
		}
		
		public function createTypeFilter():ITypeFilter
		{
			// calling this seals the matcher
			return _typeFilter ||= buildTypeFilter();
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
	}
}