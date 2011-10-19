package org.robotlegs.v2.core.impl
{
	import asunit.framework.TestCase;
	import org.robotlegs.v2.core.api.ITypeFilter;

	public class TypeFilterUsageTest extends TestCase
	{
	
		public function TypeFilterUsageTest(methodName:String=null) 
		{
			super(methodName)
		}
		
		public function test_class_matched_by_all():void {
			var subject:TypeA12 = new TypeA12();
			
			var filter:ITypeFilter = new TypeFilter(new <Class>[TypeA, IType1, IType2], new <Class>[], new <Class>[]);
			
			assertTrue("Class matched by all", itemPassesFilter(subject, filter));
		}
		
		public function test_class_not_matched_by_all():void {
			var subject:TypeA1 = new TypeA1();
			
			var filter:ITypeFilter = new TypeFilter(new <Class>[TypeA, IType1, IType2], new <Class>[], new <Class>[]);

			assertFalse("Class not matched by all", itemPassesFilter(subject, filter));
		}
		
		public function test_class_not_excluded_by_none():void {
			var subject:TypeA12 = new TypeA12();
			
			var filter:ITypeFilter = new TypeFilter(new <Class>[], new <Class>[], new <Class>[TypeB]);
			
			assertTrue("Class not excluded by none", itemPassesFilter(subject, filter));
		}
		
		public function test_class_excluded_by_none():void {
			var subject:TypeB12 = new TypeB12();
			
			var filter:ITypeFilter = new TypeFilter(new <Class>[], new <Class>[], new <Class>[TypeB]);
			
			assertFalse("Class excluded by none", itemPassesFilter(subject, filter));
		}
		
		public function test_class_matched_by_any():void {
			var subject:TypeB12 = new TypeB12();
			
			var filter:ITypeFilter = new TypeFilter(new <Class>[], new <Class>[TypeA, IType1], new <Class>[]);
			
			assertTrue("Class matched by any", itemPassesFilter(subject, filter));
		}
		
		public function test_class_not_matched_by_any():void {
			var subject:TypeB = new TypeB();
			
			var filter:ITypeFilter = new TypeFilter(new <Class>[], new <Class>[TypeA, IType1], new <Class>[]);
			
			assertFalse("Class not matched by any", itemPassesFilter(subject, filter));
		}
		
		public function test_default_behaviour_where_nothing_is_specified():void {
			var subject:TypeB = new TypeB();
			
			var filter:ITypeFilter = new TypeFilter(new <Class>[], new <Class>[], new <Class>[]);
			
			assertTrue("Default behaviour where nothing is specified is to match", itemPassesFilter(subject, filter));
		}
		
		
		protected function itemPassesFilter(item:*, typeFilter:ITypeFilter):Boolean
		{
			var allOfTypes:Vector.<Class> = typeFilter.allOfTypes;
			
			var iLength:uint = allOfTypes.length;
			for (var i:uint = 0; i < iLength; i++)
			{
				if(! (item is allOfTypes[i]))
				{
					return false;
				}
			}
			
			var noneOfTypes:Vector.<Class> = typeFilter.noneOfTypes;
			
			iLength = noneOfTypes.length;
			for (i = 0; i < iLength; i++)
			{
				if(item is noneOfTypes[i])
				{
					return false;
				}
			}
						
			var anyOfTypes:Vector.<Class> = typeFilter.anyOfTypes;
			
			if(anyOfTypes.length == 0)
			{
				return true;
			}
			
			iLength = anyOfTypes.length;
			for(i = 0; i < iLength; i++)
			{
				if(item is anyOfTypes[i])
				{
					return true;
				}
			}
			
			return false;
		}
	
	}

}