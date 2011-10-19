package org.robotlegs.v2.core.impl 
{
	import org.robotlegs.v2.core.api.ITypeMatcher;
	import org.robotlegs.v2.core.api.ITypeFilter;
	
	public class TypeMatcher implements ITypeMatcher 
	{
		protected var _allOfTypes:Vector.<Class>;
		protected var _anyOfTypes:Vector.<Class>;
		protected var _noneOfTypes:Vector.<Class>;
		
		public function TypeMatcher()
		{
			_allOfTypes = new <Class>[];
			_anyOfTypes = new <Class>[];
			_noneOfTypes = new <Class>[];
		}
		
		//---------------------------------------
		// ITypeMatcher Implementation
		//---------------------------------------

		//import org.robotlegs.v2.core.api.ITypeMatcher;
		public function get typeFilter():ITypeFilter
		{
			return new TypeFilter(_allOfTypes, _anyOfTypes, _noneOfTypes);
		}

		public function allOf(types:Vector.<Class>):ITypeMatcher
		{
			_allOfTypes = _allOfTypes.concat(types);
			return this;
		}

		public function anyOf(types:Vector.<Class>):ITypeMatcher
		{
			_anyOfTypes = _anyOfTypes.concat(types);
			return this;
		}

		public function noneOf(types:Vector.<Class>):ITypeMatcher
		{
			_noneOfTypes = _noneOfTypes.concat(types);
			return this;
		}
	}
}