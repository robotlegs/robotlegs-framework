//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.matching
{

	/**
	 * A Type Matcher matches objects that satisfy type matching rules
	 */
	public class TypeMatcher implements ITypeMatcher, ITypeMatcherFactory
	{

		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/

		protected const _allOfTypes:Vector.<Class> = new Vector.<Class>();

		protected const _anyOfTypes:Vector.<Class> = new Vector.<Class>();

		protected const _noneOfTypes:Vector.<Class> = new Vector.<Class>();

		protected var _typeFilter:ITypeFilter;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * All types that an item must extend or implement
		 */
		public function allOf(... types):TypeMatcher
		{
			pushAddedTypesTo(types, _allOfTypes);
			return this;
		}

		/**
		 * Any types that an item must extend or implement
		 */
		public function anyOf(... types):TypeMatcher
		{
			pushAddedTypesTo(types, _anyOfTypes);
			return this;
		}

		/**
		 * Types that an item must not extend or implement
		 */
		public function noneOf(... types):TypeMatcher
		{
			pushAddedTypesTo(types, _noneOfTypes);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function createTypeFilter():ITypeFilter
		{
			// calling this seals the matcher
			return _typeFilter ||= buildTypeFilter();
		}

		/**
		 * Locks this type matcher
		 * @return
		 */
		public function lock():ITypeMatcherFactory
		{
			createTypeFilter();
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function clone():TypeMatcher
		{
			return new TypeMatcher().allOf(_allOfTypes).anyOf(_anyOfTypes).noneOf(_noneOfTypes);
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

		protected function pushAddedTypesTo(types:Array, targetSet:Vector.<Class>):void
		{
			_typeFilter && throwSealedMatcherError();

			pushValuesToClassVector(types, targetSet);
		}

		protected function throwSealedMatcherError():void
		{
			throw new TypeMatcherError(TypeMatcherError.SEALED_MATCHER);
		}

		protected function pushValuesToClassVector(values:Array, vector:Vector.<Class>):void
		{
			if (values.length == 1
				&& (values[0] is Array || values[0] is Vector.<Class>))
			{
				for each (var type:Class in values[0])
				{
					vector.push(type);
				}
			}
			else
			{
				for each (type in values)
				{
					vector.push(type);
				}
			}
		}
	}
}
