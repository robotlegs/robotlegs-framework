package org.robotlegs.v2.core.impl 
{
	import flash.errors.IllegalOperationError;
	
	import org.robotlegs.v2.core.api.ITypeFilter;
	import org.robotlegs.v2.core.api.ITypeMatcher;
	
	public class TypeMatcher implements ITypeMatcher 
	{
		protected const _allOfTypes:Vector.<Class> = new Vector.<Class>;
		protected const _anyOfTypes:Vector.<Class> = new Vector.<Class>;
		protected const _noneOfTypes:Vector.<Class> = new Vector.<Class>;
		
		protected var _typeFilter:ITypeFilter;
		
		public function TypeMatcher()
		{
		}
		
		//---------------------------------------
		// ITypeMatcher Implementation
		//---------------------------------------

		public function get typeFilter():ITypeFilter
		{
			return _typeFilter ||= createTypeFilter();
		}
		
		public function allOf(types:Vector.<Class>):ITypeMatcher
		{
			_typeFilter && throwSealedError();
			_allOfTypes = _allOfTypes.concat(types);
			return this;
		}
		
		public function anyOf(types:Vector.<Class>):ITypeMatcher
		{
			_typeFilter && throwSealedError();
			_anyOfTypes = _anyOfTypes.concat(types);
			return this;
		}

		public function noneOf(types:Vector.<Class>):ITypeMatcher
		{
			_typeFilter && throwSealedError();
			_noneOfTypes = _noneOfTypes.concat(types);
			return this;
		}
		
		protected function throwSealedError():void
		{
			throw new IllegalOperationError('This TypeMatcher has been sealed and can no longer be configured');
		}
		
		protected function createTypeFilter():ITypeFilter
		{
			throwErrorIfEmpty();
			return new TypeFilter(_allOfTypes, _anyOfTypes, _noneOfTypes);
		}

		protected function throwErrorIfEmpty():void
		{
			if( (_allOfTypes.length == 0) &&
				(_anyOfTypes.length == 0) &&
				(_noneOfTypes.length == 0) )
			{
				throw new TypeMatcherError(TypeMatcherError.EMPTY_MATCHER);
			}
		}
	}
}