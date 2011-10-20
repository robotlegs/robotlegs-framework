package org.robotlegs.v2.core.impl 
{
	import flash.errors.IllegalOperationError;
	import flash.utils.getQualifiedClassName;
	
	import org.robotlegs.v2.core.api.ITypeFilter;
	
	public class TypeFilter implements ITypeFilter 
	{
		protected var _allOfTypes:Vector.<Class>;
		protected var _anyOfTypes:Vector.<Class>;
		protected var _noneOfTypes:Vector.<Class>;
		
		protected var _descriptor:String;
		
		public function TypeFilter(allOf:Vector.<Class>, anyOf:Vector.<Class>, noneOf:Vector.<Class>) 
		{
			if (!allOf || !anyOf || !noneOf)
				throw ArgumentError('TypeFilter parameters can not be null');
			_allOfTypes = allOf;
			_anyOfTypes = anyOf;
			_noneOfTypes = noneOf;
		} 
		
		public function get allOfTypes():Vector.<Class>
		{
			return _allOfTypes;
		}

		public function get anyOfTypes():Vector.<Class>
		{
			return _anyOfTypes;
		}

		public function get noneOfTypes():Vector.<Class>
		{
			return _noneOfTypes;
		}

		public function get descriptor():String
		{
			return _descriptor ||= createDescriptor();
		}
		
		protected function createDescriptor():String
		{
			var allOf_FCQNs:Vector.<String> = alphabetiseCaseInsensitiveFCQNs(allOfTypes);
			var anyOf_FCQNs:Vector.<String> = alphabetiseCaseInsensitiveFCQNs(anyOfTypes);
			var noneOf_FQCNs:Vector.<String> = alphabetiseCaseInsensitiveFCQNs(noneOfTypes);
			
			return "all of: " + allOf_FCQNs.toString()
				+ ", any of: " + anyOf_FCQNs.toString()
				+ ", none of: " + noneOf_FQCNs.toString();
		}
		
		protected function alphabetiseCaseInsensitiveFCQNs(classVector:Vector.<Class>):Vector.<String>
		{
			var fcqn:String;
			var allFCQNs:Vector.<String> = new <String>[];
			
			var iLength:uint = classVector.length;
			for (var i:uint = 0; i < iLength; i++)
			{
				fcqn = getQualifiedClassName(classVector[i]);
				allFCQNs[allFCQNs.length] = fcqn;
			}
			
			allFCQNs.sort(stringSort);
			return allFCQNs;
		} 		
		
		protected function stringSort(item1:String, item2:String):int
		{
			if(item1 < item2)
			{
				return 1;
			}
			return -1;
		}
	}
}